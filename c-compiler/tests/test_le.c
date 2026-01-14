define x;
define y;
define result;
x = 5;
y = 10;
result = 0;
if (x <= y) {
  result = 1;
}
x = 10;
y = 5;
if (x <= y) {
  result = result + 10;
}
x = 7;
y = 7;
if (x <= y) {
  result = result + 100;
}
result;
