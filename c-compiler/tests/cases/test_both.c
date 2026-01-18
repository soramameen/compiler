define x;
define y;
define z;
define result;
x = 5;
y = 10;
z = 10;
result = 0;
if (x <= y) {
  result = result + 1;
}
if (y >= z) {
  result = result + 10;
}
if (z <= y) {
  result = result + 100;
}
if (x >= y) {
  result = result + 1000;
}
x = 15;
y = 10;
if (x >= y) {
  result = result + 10000;
}
if (y <= x) {
  result = result + 100000;
}
result;
