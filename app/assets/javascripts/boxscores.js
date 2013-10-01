$(function() {
  if ($('#game_forfeit').attr("checked") == "checked") {
    $("#team_stats :input").prop("disabled", true);
    $("[name='game[winner]']").show();
  }
  else {
    $("[name='game[winner]']").hide();
  }

  $('#game_forfeit').change(function () {
    $("#team_stats :input").prop("disabled", this.checked);
    $("[name='game[winner]']").toggle();
  });
  
  $('#away_stats').on('change', '[id^="twom_"], [id^="threem_"], [id^="ftm_"]', function() { calcTotalScore("away"); });
  $('#home_stats').on('change', '[id^="twom_"], [id^="threem_"], [id^="ftm_"]', function() { calcTotalScore("home"); });
  
  $('input[id^="game_away_score_"]').change(function() { sumTotalScore("away"); });
  $('input[id^="game_home_score_"]').change(function() { sumTotalScore("home"); });
  
  calcTotalScore("away");
  calcTotalScore("home");
  sumTotalScore("away");
  sumTotalScore("home");
});

function checkTotals(team) {
  if (parseInt($('#'+team+'_score_total_sum').html()) != parseInt($('#'+team+'_score_total').html())) {
    $('#'+team+'_totals').css("color", "red");
  }
  else {
    $('#'+team+'_totals').css("color", "black");
  }
}

function sumTotalScore(team) {
  var total = 0;
  $('input[id^="game_'+team+'_score_"]').each(function() {
    total += parseInt($(this).val());
  });
  $('#'+team+'_score_total_sum').html(total);
  
  checkTotals(team);
}

function calcTotalScore(team) {
  var total = 0;
  //2 pointers
  $('#'+team+'_stats [id^="twom_"]').each(function() {
    if ($(this).val()) {
      total += (parseInt($(this).val()) * 2);
    }
  });
  //3 pointers
  $('#'+team+'_stats [id^="threem_"]').each(function() {
    if ($(this).val()) {
      total += (parseInt($(this).val()) * 3);
    }
  });
  //free throws
  $('#'+team+'_stats [id^="ftm_"]').each(function() {
    if ($(this).val()) {
      total += (parseInt($(this).val()));
    }
  });
  $('#'+team+'_score_total').html(total);
  
  checkTotals(team);
}

function validateInputs() {
  var broken = false;
  $('[id^="stat_"]').each(function() {
    var stat_id = $(this).attr("id").split("_")[1];
    var player_name = $(this).text();

    var made = $('#twom_' + stat_id).val();
    var attempted = $('#twoa_' + stat_id).val();
    if (parseInt(made) > parseInt(attempted)) {
      alert("2PM for " + player_name + " greater than 2PA");
      broken = true;
      return false;
    }

    made = $('#threem_' + stat_id).val();
    attempted = $('#threea_' + stat_id).val();
    if (parseInt(made) > parseInt(attempted)) {
      alert("3PM for " + player_name + " greater than 3PA");
      broken = true;
      return false;
    }

    made = $('#ftm_' + stat_id).val();
    attempted = $('#fta_' + stat_id).val();
    if (parseInt(made) > parseInt(attempted)) {
      alert("FTM for " + player_name + " greater than FTA");
      broken = true;
      return false;
    }
  });

  return !broken;
}

var subCount = 0;
function addSub(team) {
  var table = $('#team_' + team);
  subCount++;
  var sub_id = 'sub' + subCount;
  var team_id = 'sub_' + team + '_' + subCount;
  table.append('<tr>\
    <td><span id="stat_sub0">Sub</span></td>\
    <td><input id="jersey_number_sub0" name="stat_lines[sub_0[jersey_number]]" type="number" min="0" value=""></td>\
    <td style="text-align:center;">\
    <input name="stat_lines[sub_0[dnp]]" type="hidden" value="0">\
    <input id="dnp_sub0" name="stat_lines[sub_0[dnp]]" type="checkbox" value="1"></td>\
    <td><input id="twom_sub0" name="stat_lines[sub_0[twom]]" type="number" min="0" value="0"></td>\
    <td><input id="twoa_sub0" name="stat_lines[sub_0[twoa]]" type="number" min="0" value="0"></td>\
    <td><input id="threem_sub0" name="stat_lines[sub_0[threem]]" type="number" min="0" value="0"></td>\
    <td><input id="threea_sub0" name="stat_lines[sub_0[threea]]" type="number" min="0" value="0"></td>\
    <td><input id="ftm_sub0" name="stat_lines[sub_0[ftm]]" type="number" min="0" value="0"></td>\
    <td><input id="fta_sub0" name="stat_lines[sub_0[fta]]" type="number" min="0" value="0"></td>\
    <td><input id="orb_sub0" name="stat_lines[sub_0[orb]]" type="number" min="0" value="0"></td>\
    <td><input id="drb_sub0" name="stat_lines[sub_0[drb]]" type="number" min="0" value="0"></td>\
    <td><input id="ast_sub0" name="stat_lines[sub_0[ast]]" type="number" min="0" value="0"></td>\
    <td><input id="stl_sub0" name="stat_lines[sub_0[stl]]" type="number" min="0" value="0"></td>\
    <td><input id="blk_sub0" name="stat_lines[sub_0[blk]]" type="number" min="0" value="0"></td>\
    <td><input id="fl_sub0" name="stat_lines[sub_0[fl]]" type="number" min="0" value="0"></td>\
    <td><input id="to_sub0" name="stat_lines[sub_0[to]]" type="number" min="0" value="0"></td>\
    </tr>'.replace(/sub0/g, sub_id).replace(/sub_0/g, team_id));
}