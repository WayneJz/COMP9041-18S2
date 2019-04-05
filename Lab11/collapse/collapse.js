(function() {
  'use strict';
  // TODO: Write some js
  const collapse_1 = document.getElementById('item-1');
  collapse_1.onclick = function(){
    const to_collapse_2 = document.getElementById('item-1-content');
    if (to_collapse_2.style.display == 'block'){
      to_collapse_2.style.display = 'none';
    }
    else{
      to_collapse_2.style.display = 'block';
    }
  };
  const collapse_2 = document.getElementById('item-2');
  collapse_2.onclick = function(){
    const to_collapse_2 = document.getElementById('item-2-content');
    if (to_collapse_2.style.display == 'block'){
      to_collapse_2.style.display = 'none';
    }
    else{
      to_collapse_2.style.display = 'block';
    }
  };
}());
