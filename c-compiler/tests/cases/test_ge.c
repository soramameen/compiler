define x;
define y;
define result;
x = 10;
y = 5;
result = 0;
if (x >= y) {
  result = 1;
}
x = 5;
y = 10;
if (x >= y) {
  result = result + 10;
}
x = 7;
y = 7;
if (x >= y) {
  result = result + 100;
}
result;
