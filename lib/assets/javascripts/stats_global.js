$(function () {
  $('.scroll-pane').jScrollPane();

  $('.bxslider').bxSlider({
    mode: 'fade',
    captions: true,
    controls: true,
    auto: true,
    preloadImages: 'all',
  });

  $.get('/api/standings');
});

function setStandings(data) {
  $('#standings').html(data);
  $('.scroll-pane').jScrollPane();
  $('a.showlink').css("text-decoration", "none");
  $("#show_" + leagueDay).css("text-decoration", "underline").click();

  $('a.showlink').click(function() {
    $('a.showlink').css("text-decoration", "none");
    $(this).css("text-decoration", "underline");
    var toShow = this.id.substr(5);
    $('div.section:visible').fadeOut(1, function() {
      $('#' + toShow).fadeIn(1, function() {
        $('.scroll-pane').jScrollPane()
      });
    });
  });
}