define i;
define j;
define k;
array matrix1[3][3];
array matrix2[3][3];
array matrix3[3][3];
while (i < 3) {
  while (j < 3) {
    k = 0;
    matrix3[i][j] = 0;
    while (k < 3) {
      matrix3[i][j] = matrix3[i][j] + matrix1[i][k] * matrix2[k][j];
      k = k + 1;
    }
    j = j + 1;
  }
  j = 0;
  i = i + 1;
}
