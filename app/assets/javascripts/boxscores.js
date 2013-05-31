$(function() {
  if ($('#game_forfeit').checked) {
    $("#team_stats :input").prop("disabled", true);
  }
  
  $('#game_forfeit').change(function () {
    $("#team_stats :input").prop("disabled", this.checked ? true : false);
  });
});

function validateInputs() {
  $('[id^="stat_"]').each(function() {
    var stat_id = $(this).attr("id").split("_")[1];
    var player_name = $(this).text();

    var made = $('#twom_' + stat_id).val();
    var attempted = $('#twoa_' + stat_id).val();
    if (parseInt(made) > parseInt(attempted)) {
      alert("2PM for " + player_name + " greater than 2PA");
      return false;
    }

    made = $('#threem_' + stat_id).val();
    attempted = $('#threea_' + stat_id).val();
    if (parseInt(made) > parseInt(attempted)) {
      alert("3PM for " + player_name + " greater than 3PA");
      return false;
    }

    made = $('#ftm_' + stat_id).val();
    attempted = $('#fta_' + stat_id).val();
    if (parseInt(made) > parseInt(attempted)) {
      alert("FTM for " + player_name + " greater than FTA");
      return false;
    }
  });

  return true;
}

var subCount = 0;
function addSub(team) {
  var table = $('#team_' + team);
  subCount++;
  var sub_id = 'sub' + subCount;
  var team_id = 'sub_' + team + '_' + subCount;
  table.append('<tr>\
    <td><span id="stat_sub0">Sub</span></td>\
    <td style="text-align:center;">\
    <input name="stat_lines[sub_0[dnp]]" type="hidden" value="0">\
    <input id="dnp_sub0" name="stat_lines[sub_0[dnp]]" type="checkbox" value="1"></td>\
    <td><input id="fgm_sub0" name="stat_lines[sub_0[twom]]" type="number" min="0" value="0"></td>\
    <td><input id="fga_sub0" name="stat_lines[sub_0[twoa]]" type="number" min="0" value="0"></td>\
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