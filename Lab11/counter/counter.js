(function() {
   'use strict';
   // write your code here
  const counterwindow = document.getElementById('output')
  var num = 0;
  setInterval(function (){
      num += 1;
      counterwindow.innerHTML = num;
    }, 1000);
}());
