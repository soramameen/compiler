#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>

#define MAX_STR_LEN 69
#define MAX 1024
#define MAX_PROFILES 10000
#define NUM_CHILDREN 1000  // あらかじめ生成する子プロセスの数

/* --- 名簿管理データ構造 --- */
struct date {
    int y;
    int m;
    int d;
};

struct profile {
    int id;
    char name[MAX_STR_LEN + 1];
    struct date birthday;
    char address[MAX_STR_LEN + 1];
    char *comment;
};

struct profile profile_data_store[MAX_PROFILES];
int profile_data_nitems = 0;
int debug_mode = 1;

/* --- 補助関数 --- */
int subst(char *str, char c1, char c2) {
    int count = 0;
    while (*str) {
        if (*str == c1) {
            *str = c2;
            count++;
        }
        str++;
    }
    return count;
}

int split(char *str, char *ret[], char sep, int max) {
    int i = 0;
    ret[i] = str;
    while (*str) {
        if (*str == sep) {
            *str = '\0';
            ret[++i] = str + 1;
            if (i >= max - 1) break;
        }
        str++;
    }
    return i + 1;
}

struct date *new_date(struct date *d, char *str) {
    char *ptr[3];
    if (split(str, ptr, '-', 3) != 3) return NULL;
    d->y = atoi(ptr[0]);
    d->m = atoi(ptr[1]);
    d->d = atoi(ptr[2]);
    return d;
}

struct profile *new_profile(struct profile *p, char *csv) {
    char *ptr[5];
    if (split(csv, ptr, ',', 5) != 5) return NULL;
    p->id = atoi(ptr[0]);
    strncpy(p->name, ptr[1], MAX_STR_LEN);
    p->name[MAX_STR_LEN] = '\0';
    if (new_date(&p->birthday, ptr[2]) == NULL) return NULL;
    strncpy(p->address, ptr[3], MAX_STR_LEN);
    p->address[MAX_STR_LEN] = '\0';
    p->comment = (char *)malloc(sizeof(char) * (strlen(ptr[4]) + 1));
    strcpy(p->comment, ptr[4]);
    return p;
}

/* --- コマンド関数 --- */
void cmd_quit(int fd) {
    char buf[MAX];
    int len = sprintf(buf, "Goodbye (from process %d)!\n", getpid());
    write(fd, buf, len);
}

void cmd_check(int fd) {
    char buf[MAX];
    int len = sprintf(buf, "%d profile(s) in process %d\n", profile_data_nitems, getpid());
    write(fd, buf, len);
}

void cmd_print(int fd, int count) {
    char buf[MAX];
    if (count <= 0 || count > profile_data_nitems) count = profile_data_nitems;
    for (int j = 0; j < count; ++j) {
        int len = sprintf(buf, "Id    : %d\nName  : %s\nBirth : %04d-%02d-%02d\nAddr. : %s\nComm. : %s\n\n",
               profile_data_store[j].id, profile_data_store[j].name,
               profile_data_store[j].birthday.y, profile_data_store[j].birthday.m, profile_data_store[j].birthday.d,
               profile_data_store[j].address, profile_data_store[j].comment);
        write(fd, buf, len);
    }
}

void exec_command(int fd, char cmd, char *param) {
    switch (cmd) {
        case 'Q': cmd_quit(fd); break;
        case 'C': cmd_check(fd); break;
        case 'P': cmd_print(fd, atoi(param)); break;
        default:  write(fd, "Unknown command\n", 16); break;
    }
}

void parse_line(int fd, char *line) {
    if (line[0] == '%') {
        exec_command(fd, line[1], line + 3);
    } else {
        if (profile_data_nitems < MAX_PROFILES) {
            struct profile new_p;
            if (new_profile(&new_p, line) != NULL) {
                profile_data_store[profile_data_nitems++] = new_p;
                write(fd, "Profile added.\n", 15);
            }
        }
    }
}

/* --- メイン関数 (Prefork Server) --- */
int main() {
    int s;
    struct sockaddr_in sa;
    pid_t pids[NUM_CHILDREN];

    s = socket(AF_INET, SOCK_STREAM, 0);
    int opt = 1;
    setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    memset(&sa, 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_port = htons(61001);
    sa.sin_addr.s_addr = htonl(INADDR_ANY);

    if (bind(s, (struct sockaddr*)&sa, sizeof(sa)) < 0) {
        perror("bind");
        return 1;
    }

    listen(s, 5);
    printf("Prefork Server started. Forking %d children...\n", NUM_CHILDREN);

    for (int i = 0; i < NUM_CHILDREN; i++) {
        pids[i] = fork();
        if (pids[i] == 0) {
            // 子プロセス
            printf("Child process %d (PID: %d) ready to accept.\n", i, getpid());
            while (1) {
                int new_s = accept(s, NULL, NULL);
                if (new_s < 0) continue;

                printf("[Process %d] Accepted connection.\n", getpid());
                char recv_buf[MAX];
                while (1) {
                    memset(recv_buf, 0, sizeof(recv_buf));
                    if (recv(new_s, recv_buf, sizeof(recv_buf) - 1, 0) <= 0) break;
                    subst(recv_buf, '\n', '\0');
                    subst(recv_buf, '\r', '\0');
                    parse_line(new_s, recv_buf);
                    write(new_s, "\0", 1); // 終端文字
                    if (strncmp(recv_buf, "%Q", 2) == 0) break;
                }
                close(new_s);
                printf("[Process %d] Connection closed.\n", getpid());
            }
            exit(0);
        }
    }

    // 親プロセスは子プロセスの終了を待つ
    for (int i = 0; i < NUM_CHILDREN; i++) {
        wait(NULL);
    }

    close(s);
    return 0;
}
