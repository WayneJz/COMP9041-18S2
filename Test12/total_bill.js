function total_bill(bill_list) {

  // PUT YOUR CODE HERE
  var total = 0;
  for (let i = 0; i < bill_list.length; i ++){
    for (let j = 0; j < bill_list[i].length; j ++){
      total += parseFloat(bill_list[i][j].price.slice(1));
    }
  }
  return total;
}

module.exports = total_bill;
