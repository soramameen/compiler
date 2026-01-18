define a;
define b;
define resne;
define resgt;
a = 10;
b = 5;
resne = 0;
resgt = 0;
if (a != b) {
  resne = 1;
}
if (a > b) {
  resgt = 1;
}
if (a != 10) {
   resne = 0;
}
if (b > 10) {
   resgt = 0;
}
resne + resgt;
