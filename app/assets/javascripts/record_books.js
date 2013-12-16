$(function() {
  $('.record_link').click(function () {
    if (!$(this).hasClass('active')) {
      $(this).addClass('active');
      switch ($(this).attr('id')){
        case 'cpergame_link':
          $('#ctotals_link').removeClass('active');
          $('#ctotals').addClass('inactive');
          $('#cpergame').removeClass('inactive');
          break;
        case 'ctotals_link':
          $('#cpergame_link').removeClass('active');
          $('#cpergame').addClass('inactive');
          $('#ctotals').removeClass('inactive');
          break;
        case 'spergame_link':
          $('#stotals_link').removeClass('active');
          $('#stotals').addClass('inactive');
          $('#spergame').removeClass('inactive');
          break;
        case 'stotals_link':
          $('#spergame_link').removeClass('active');
          $('#spergame').addClass('inactive');
          $('#stotals').removeClass('inactive');
          break;
      }
    }
  });
});