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


// new scripts

// Scroll Pane
$(function() {
  $('.scroll-pane').jScrollPane();
  $('.scroll-upcoming').jScrollPane();
});
// Get standings
function setStandings(data) {
  $('#standings').html(data);
  $('.scroll-pane').jScrollPane();
  $('.scroll-upcoming').jScrollPane();
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
}
$.getJSON("http://stats.abchoops.com/api/standings?callback=?");
// Popover for Player Search
$(document).ready(function() {
  $("[data-toggle=popover]").popover({
    html: true,
    placement: 'left',
    content: function() {
      return $('#findaplayer').html();
    }
  });
});
// Header Slide
$(document).ready(function() {
  $(window).scroll(function() {
    console.log($(window).scrollTop())
    if ($(window).scrollTop() > 24) {
      $('.navbar').addClass('navbar-fixed');
      $('.main-container').addClass('main-container-fixed');
      $('.lower-diag-bar').addClass('lower-diag-bar-fixed');
    }
    if ($(window).scrollTop() < 24) {
      $('.navbar').removeClass('navbar-fixed');
      $('.main-container').removeClass('main-container-fixed');
      $('.lower-diag-bar').removeClass('lower-diag-bar-fixed');
    }
  });
});
$(document).ready(resizeMenuDropdown);
$(window).on('resize', resizeMenuDropdown);

function resizeMenuDropdown() {
  if ($(window).width() < 768) {
    $(".dropdown-toggle").addClass("disabled");
  } else {
    $(".dropdown-toggle").removeClass("disabled")
  };
}
resizeMenuDropdown();
$(window).resize(resizeMenuDropdown);
// Hide popover
$(document).keyup(function(event) {
  if (event.which === 27) {
    $('[data-toggle=popover]').popover('hide');
  }
});
// Hide Popover
$('html').on('click', function(e) {
  if (typeof $(e.target).data('toggle=popover') == 'undefined' && !$(e.target).parents().is('.popover.in') && !$(e.target).parents().is('.find-a-player-toggle')) {
    $('[data-toggle=popover]').popover('hide');
  }
});
//sort table
$.extend($.fn.bootstrapTable.columnDefaults, {
  sortable: true
});
$(function() {
  $('.sortable').bootstrapTable();
});
// Show Tooltip
$(function() {
    $('[data-toggle="tooltip"]').tooltip()
  })
  //Carousel
$(document).ready(function() {
  var height = $(window).height() - 40; //getting windows height
  jQuery('#myCarousel').css('height', height + 'px') - 40; //and setting height of carousel
  jQuery('.carousel .item').css('height', height + 'px');
});
// Reorder items in player box on resize
$(document).ready(function() {
  $(window).on('load resize', function() {
    resize('.highlight-stat-table-container', '.subhead-container', '.half-ball-background');
  });
});

function resize(el1, el2, el3) {
  var $window = $(window);
  if ($window.width() <= 499) {
    $(el1).insertAfter(el3);
  } else {
    $(el1).insertAfter(el2);
  }
}
// click menu to load main page on mobile
$(document).ready(resizeMenuDropdown);
$(window).on('resize', resizeMenuDropdown);

function resizeMenuDropdown() {
  if ($(window).width() < 768) {
    $(".dropdown-toggle").addClass("disabled");
  } else {
    $(".dropdown-toggle").removeClass("disabled")
  };
}
resizeMenuDropdown();
$(window).resize(resizeMenuDropdown);

//responsive tables
$(document).ready(function() {
  var switched = false;
  var updateTables = function() {
    if (($(window).width() < 767) && !switched) {
      switched = true;
      $("table.responsive").each(function(i, element) {
        splitTable($(element));
      });
      return true;
    } else if (switched && ($(window).width() > 767)) {
      switched = false;
      $("table.responsive").each(function(i, element) {
        unsplitTable($(element));
      });
    }
  };
  $(window).load(updateTables);
  $(window).bind("resize", updateTables);

  function splitTable(original) {
    original.wrap("<div class='table-wrapper' />");
    var copy = original.clone();
    copy.find("td:not(.r-lock), th:not(.r-lock)").css("display", "none");
    copy.removeClass("responsive");
    original.closest(".table-wrapper").append(copy);
    copy.wrap("<div class='pinned' />");
    original.wrap("<div class='scrollable' />");
  }

  function unsplitTable(original) {
    original.closest(".table-wrapper").find(".pinned").remove();
    original.unwrap();
    original.unwrap();
  }
});