$(function () {
  $('.scroll-pane').jScrollPane();

  //sidebar
  $('a.showlink').css("text-decoration", "none");
  $("#show_Sun").css("text-decoration", "underline").click();

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
});