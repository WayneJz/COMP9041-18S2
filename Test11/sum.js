
function sum(list) {

  // PUT YOUR CODE HERE
  var sum = 0;
  for(var i=0; i < list.length; i++){
     sum += parseInt(list[i]);
  }
  return sum;
}

module.exports = sum;
