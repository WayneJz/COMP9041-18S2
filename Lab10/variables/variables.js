/*
 * This code is broken! Can you figure out why
 * and fix it?
 */

function doubleIfEven(n) {
  x = n;
  if(even(x)) return double(x);
  return x;
}

function even(a) {
  if(a % 2==0) return true;
  else return false;
}

function double(a) {
  return a*2;
}


module.exports = doubleIfEven;
