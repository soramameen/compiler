#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netdb.h>
#include <string.h>
#include <stdio.h>

#define MAX 1024

int main(){
  struct addrinfo hints, *res;
  char send_buf[MAX];
  char recv_buf[MAX];

  memset(&hints, 0, sizeof(hints));
  hints.ai_socktype= SOCK_STREAM; // TCP
  hints.ai_family =AF_INET; // IPv4

  char* dmain = "localhost";
  int error = getaddrinfo(dmain,"61001", &hints, &res);
  if (error){
    printf("error\n");
    return -1;
  }
  int s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
  int i = connect(s, res->ai_addr, res->ai_addrlen);
  if (i==-1){
    printf("connection error\n");
    return -1;
  }

  while (1){
    printf("> ");
    fflush(stdout);
    if (fgets(send_buf, MAX, stdin) == NULL){
      break;
    }
    // 末尾の改行を削除しnull文字を追加
    send_buf[strcspn(send_buf, "\n")] = '\0';

    int total_sent = 0;
    int len = strlen(send_buf) + 1; // ヌル文字も含めて送信する
    while (total_sent < len) {
      ssize_t n = send(s, send_buf + total_sent, len - total_sent, 0);
      if (n == -1) {
        perror("send error");
        break;
      }
      total_sent += n;
    }

    while (1) {
      ssize_t n = read(s, recv_buf, 5);
      if (n <= 0) {
        break;
      }

      int found_null = 0;
      int display_len = n;
      for (int j = 0; j < n; j++) {
        if (recv_buf[j] == '\0') {
          found_null = 1;
          display_len = j;
          break;
        }
      }

      int total_displayed = 0;
      while (total_displayed < display_len) {
        ssize_t wn = write(1, recv_buf + total_displayed, display_len - total_displayed);
        if (wn == -1) break;
        total_displayed += wn;
      }

      if (found_null) break;
    }

    if (strncmp(send_buf, "%Q", 2) == 0){
      break;
    }
  }
  close(s);
  return 0;
}
