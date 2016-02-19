$(function () {
  $('.scroll-pane').jScrollPane();

  $('.bxslider').bxSlider({
    mode: 'fade',
    captions: true,
    controls: true,
    auto: true, 
    preloadImages: 'all',
  });

  $.get('/api/standings?league_id=' + window.currentLeagueId);
});

function setStandings(data) {
  $('#sidebarStandings').html(data);
  $('#sidebarStandings .scroll-pane').jScrollPane();

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