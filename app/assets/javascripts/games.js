$(function() {
  $('#games_game0_time').change(function() {
    var count = 1;
    var selected_index = this.selectedIndex;
    while ($('#games_game'+count+'_time').length > 0) {
      selected_index += 4;
      $('#games_game'+count+'_time')[0].selectedIndex = selected_index;
      count++;
    }
  });
  
  $('#add_photo_url').click(addPhotoUrl);
});

function addPhotoUrl() {
  var i = 1;
  while ($('#photo_urls_' + i).length) {
    i++;
  }
  
  $('#photo_urls_1').clone().attr({
    id: "photo_urls_" + i,
    name: "photo_urls[" + i + "]"
  }).val('').appendTo('#photo_urls');
}