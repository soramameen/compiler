array arr[2][3];
define sum;
define i;
define j;
arr[0][0] = 1;
arr[0][1] = 2;
arr[0][2] = 3;
arr[1][0] = 4;
arr[1][1] = 5;
arr[1][2] = 6;
sum = 0;
i = 0;
while (i < 2) {
    j = 0;
    while (j < 3) {
        sum = sum + arr[i][j];
        j = j + 1;
    }
    i = i + 1;
}
sum;
