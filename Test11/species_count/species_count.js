function species_count(target_species, whale_list) {

  // PUT YOUR CODE HERE
  var count = 0;
  for (var i=0; i < whale_list.length; i++){
    if (whale_list[i]["species"] === target_species){
       count += whale_list[i]["how_many"];
    }
  }
  return count;
}

module.exports = species_count;
