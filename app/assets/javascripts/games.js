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
});