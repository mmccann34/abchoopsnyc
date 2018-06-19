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

  $(document).on("click","#edit-urls", function(e){
    $("#urls").show();
    $(".photo-list").hide();
    e.preventDefault();
  });
  
  $('#add_photo_url').click(addPhotoUrl);
  $('.delete_url').click(removePhotoUrl);
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

function removePhotoUrl() {
  cache = $(this).closest(".url_set")
    cache.fadeOut
      cache.remove()
      null
}

$(document).ready(function(){
  $(".game_photos_indicator").hide();
  $('.hide_game_photos').hide();
  $(".show_game_photos").show();

  $('.show_game_photos').click(function(){
    $(".game_photos_indicator").show();
    $('.hide_game_photos').show();
    $('.show_game_photos').hide();
  });
  $('.hide_game_photos').click(function(){
    $(".game_photos_indicator").hide();
    $('.hide_game_photos').hide();
    $('.show_game_photos').show();
  });
});