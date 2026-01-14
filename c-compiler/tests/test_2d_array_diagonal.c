array arr[3][3];
define sum;
define i;
arr[0][0] = 1;
arr[0][1] = 2;
arr[0][2] = 3;
arr[1][0] = 4;
arr[1][1] = 5;
arr[1][2] = 6;
arr[2][0] = 7;
arr[2][1] = 8;
arr[2][2] = 9;
sum = 0;
i = 0;
while (i < 3) {
    sum = sum + arr[i][i];
    i = i + 1;
}
sum;
