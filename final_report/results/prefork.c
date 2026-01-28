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
#define RECV_BUF_LEN 5
#define NUM_CHILDREN 3

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

void swap_profile(struct profile *p1, struct profile *p2) {
    struct profile tmp;
    tmp = *p2;
    *p2 = *p1;
    *p1 = tmp;
}

void sort_id(struct profile *p, struct profile *q) {
    if (p->id > q->id) swap_profile(p, q);
}

void sort_birthday(struct profile *p, struct profile *q) {
    char str_p[MAX], str_q[MAX];
    sprintf(str_p, "%04d%02d%02d", p->birthday.y, p->birthday.m, p->birthday.d);
    sprintf(str_q, "%04d%02d%02d", q->birthday.y, q->birthday.m, q->birthday.d);
    if (strcmp(str_p, str_q) > 0) swap_profile(p, q);
}

void sort_name(struct profile *p, struct profile *q) {
    if (strcmp(p->name, q->name) > 0) swap_profile(p, q);
}

void sort_add(struct profile *p, struct profile *q) {
    if (strcmp(p->address, q->address) > 0) swap_profile(p, q);
}

void sort_comm(struct profile *p, struct profile *q) {
    if (strcmp(p->comment, q->comment) > 0) swap_profile(p, q);
}

void cmd_quit(int fd) {
    char buf[MAX];
    int len = sprintf(buf, "Goodbye! (PID: %d)\n", getpid());
    if (debug_mode) printf("%s", buf);
    write(fd, buf, len);
}

void cmd_check(int fd) {
    char buf[MAX];
    int len = sprintf(buf, "%d profile(s) (PID: %d)\n", profile_data_nitems, getpid());
    if (debug_mode) printf("%s", buf);
    write(fd, buf, len);
}

void cmd_print(int fd, int count) {
    char buf[MAX];
    int j = 0;
    if (count == 0) count = profile_data_nitems;
    
    int start = 0, end = 0;
    if (count < 0) {
        count = -count;
        if (count > profile_data_nitems) count = profile_data_nitems;
        start = profile_data_nitems - count;
        end = profile_data_nitems;
    } else {
        if (count > profile_data_nitems) count = profile_data_nitems;
        start = 0;
        end = count;
    }

    for (j = start; j < end; ++j) {
        int len = sprintf(buf, "Id    : %d\nName  : %s\nBirth : %04d-%02d-%02d\nAddr. : %s\nComm. : %s\n\n",
               profile_data_store[j].id, profile_data_store[j].name,
               profile_data_store[j].birthday.y, profile_data_store[j].birthday.m, profile_data_store[j].birthday.d,
               profile_data_store[j].address, profile_data_store[j].comment);
        if (debug_mode) printf("%s", buf);
        write(fd, buf, len);
    }
}

void cmd_read(int fd, char *filename) {
    char buf[MAX];
    FILE *file = fopen(filename, "r");
    if (file == NULL) { 
        int len = sprintf(buf, "Error: Cannot open file %s\n", filename);
        if (debug_mode) printf("%s", buf);
        write(fd, buf, len);
        return; 
    }
    char line[MAX + 1];
    int count = 0;
    while (fgets(line, sizeof(line), file)) {
        subst(line, '\n', '\0');
        if (profile_data_nitems < MAX_PROFILES) {
            struct profile new_p;
            if (new_profile(&new_p, line) != NULL) {
                profile_data_store[profile_data_nitems++] = new_p;
                count++;
            }
        }
    }
    fclose(file);
    int len = sprintf(buf, "Data read from %s successfully (%d items). (PID: %d)\n", filename, count, getpid());
    if (debug_mode) printf("%s", buf);
    write(fd, buf, len);
}

void cmd_write(int fd, char *filename) {
    char buf[MAX];
    FILE *file = fopen(filename, "w");
    if (file == NULL) { 
        int len = sprintf(buf, "Error: Cannot open file %s for writing\n", filename);
        if (debug_mode) printf("%s", buf);
        write(fd, buf, len);
        return; 
    }
    for (int i = 0; i < profile_data_nitems; i++) {
        struct profile *p = &profile_data_store[i];
        fprintf(file, "%d,%s,%04d-%02d-%02d,%s,%s\n",
                p->id, p->name, p->birthday.y, p->birthday.m, p->birthday.d, p->address, p->comment);
    }
    fclose(file);
    int len = sprintf(buf, "Data written to %s successfully. (PID: %d)\n", filename, getpid());
    if (debug_mode) printf("%s", buf);
    write(fd, buf, len);
}

void cmd_find(int fd, char *word) {
    char buf[MAX];
    int count = 0;
    for (int i = 0; i < profile_data_nitems; i++) {
        struct profile *p = &profile_data_store[i];
        int hit = 0;
        char s[20];

        sprintf(s, "%d", p->id);
        if (strcmp(s, word) == 0) hit = 1;
        if (!hit && (strcmp(word, p->name) == 0 || strcmp(word, p->address) == 0 || (p->comment && strcmp(word, p->comment) == 0))) hit = 1;
        
        char birth[20];
        sprintf(birth, "%04d-%02d-%02d", p->birthday.y, p->birthday.m, p->birthday.d);
        if (!hit && strcmp(word, birth) == 0) hit = 1;

        if (hit) {
            int len = sprintf(buf, "Id    : %d\nName  : %s\nBirth : %04d-%02d-%02d\nAddr. : %s\nComm. : %s\n\n",
                   p->id, p->name, p->birthday.y, p->birthday.m, p->birthday.d, p->address, p->comment);
            if (debug_mode) printf("%s", buf);
            write(fd, buf, len);
            count++;
        }
    }
    int len = sprintf(buf, "%d item(s) found. (PID: %d)\n", count, getpid());
    if (debug_mode) printf("%s", buf);
    write(fd, buf, len);
}

void cmd_sort(int fd, int column) {
    char buf[MAX];
    for (int i = 0; i < profile_data_nitems; i++) {
        for (int j = 0; j < profile_data_nitems - 1; j++) {
            switch (column) {
                case 1: sort_id(&profile_data_store[j], &profile_data_store[j+1]); break;
                case 2: sort_name(&profile_data_store[j], &profile_data_store[j+1]); break;
                case 3: sort_birthday(&profile_data_store[j], &profile_data_store[j+1]); break;
                case 4: sort_add(&profile_data_store[j], &profile_data_store[j+1]); break;
                case 5: sort_comm(&profile_data_store[j], &profile_data_store[j+1]); break;
            }
        }
    }
    int len = sprintf(buf, "Sorted by column %d. (PID: %d)\n", column, getpid());
    if (debug_mode) printf("%s", buf);
    write(fd, buf, len);
}

void cmd_delete(int fd, int id) {
    char buf[MAX];
    int count = 0;
    for (int i = 0; i < profile_data_nitems; i++) {
        if (profile_data_store[i].id == id) {
            free(profile_data_store[i].comment);
            for (int j = i; j < profile_data_nitems - 1; j++) {
                profile_data_store[j] = profile_data_store[j+1];
            }
            profile_data_nitems--;
            i--;
            count++;
        }
    }
    int len = sprintf(buf, "%d profile(s) deleted. (PID: %d)\n", count, getpid());
    if (debug_mode) printf("%s", buf);
    write(fd, buf, len);
}

void free_profiles() {
    for (int i = 0; i < profile_data_nitems; i++) {
        free(profile_data_store[i].comment);
    }
    profile_data_nitems = 0;
}

void exec_command(int fd, char cmd, char *param) {
    switch (cmd) {
        case 'Q': cmd_quit(fd); break;
        case 'C': cmd_check(fd); break;
        case 'P': cmd_print(fd, atoi(param)); break;
        case 'R': cmd_read(fd, param); break;
        case 'W': cmd_write(fd, param); break;
        case 'F': cmd_find(fd, param); break;
        case 'S': cmd_sort(fd, atoi(param)); break;
        case 'D': cmd_delete(fd, atoi(param)); break;
        default:  {
            char buf[MAX];
            int len = sprintf(buf, "Invalid command %c\n", cmd);
            if (debug_mode) printf("%s", buf);
            write(fd, buf, len);
            break;
        }
    }
}

void parse_line(int fd, char *line) {
    if (line[0] == '%') {
        exec_command(fd, line[1], line + 3);
    } else {
        if (profile_data_nitems < MAX_PROFILES) {
            struct profile new_p;
            struct profile *res = new_profile(&new_p, line);
            if (res != NULL) {
                profile_data_store[profile_data_nitems++] = new_p;
                char buf[MAX];
                int len = sprintf(buf, "Profile added successfully. (PID: %d)\n", getpid());
                if (debug_mode) printf("%s", buf);
                write(fd, buf, len);
            } else {
                char buf[MAX];
                int len = sprintf(buf, "Error: Invalid profile format.\n");
                if (debug_mode) printf("%s", buf);
                write(fd, buf, len);
            }
        } else {
            char buf[MAX];
            int len = sprintf(buf, "Error: Data store full.\n");
            if (debug_mode) printf("%s", buf);
            write(fd, buf, len);
        }
    }
}

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
            printf("Child process %d (PID: %d) ready to accept.\n", i, getpid());
            while (1) {
                int new_s = accept(s, NULL, NULL);
                if (new_s < 0) continue;

                printf("[PID: %d] Client connected!\n", getpid());
                char recv_buf[MAX];

                while (1) {
                    int total_received = 0;
                    int found_null = 0;
                    memset(recv_buf, 0, sizeof(recv_buf));
                    while (total_received < MAX - 1) {
                        ssize_t n = recv(new_s, recv_buf + total_received, sizeof(recv_buf) - 1 - total_received, 0);
                        if (n <= 0) break;

                        for (int j = 0; j < n; j++) {
                            if (recv_buf[total_received + j] == '\0') {
                                found_null = 1;
                                break;
                            }
                        }
                        total_received += n;
                        if (found_null) break;
                    }

                    if (found_null == 0) break;
                    
                    subst(recv_buf, '\n', '\0');
                    subst(recv_buf, '\r', '\0');
                    
                    printf("[PID: %d] Received: [%s]\n", getpid(), recv_buf);

                    parse_line(new_s, recv_buf);

                    write(new_s, "\0", 1);

                    if (strncmp(recv_buf, "%Q", 2) == 0) break;
                }
                close(new_s);
                printf("[PID: %d] Client disconnected. Waiting for next...\n", getpid());
            }
            exit(0);
        }
    }

    for (int i = 0; i < NUM_CHILDREN; i++) {
        wait(NULL);
    }

    close(s);
    return 0;
}
