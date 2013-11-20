$(function() {
  $('#findPlayer').dataTable({
    "sDom": "<'row'<'span9'f>r>t<'row'<'span4'i><'span5'p>>",
    "sPaginationType": "bootstrap",
    "iDisplayLength": 5,
    "bLengthChange": false,
    "aoColumnDefs": [ { "bSortable": false, "bSearchable": false, "aTargets": [ 0, 3 ] } ],
    "aaSorting": [[2,'asc']],
    "oLanguage": { "sInfo": "Showing _START_ to _END_ of _TOTAL_ Players" },
    "bServerSide": true,
    "sAjaxSource": $('#findPlayer').data('source'),
    "fnServerParams": function ( aoData ) {
      aoData.push({ name: "team_id", value: gon.team_id }); 
      aoData.push({ name: "season_id", value: gon.season_id }); 
      console.log(aoData);
    }
  });
  
  $("#roster input").click(function(event){
    event.stopPropagation();
  });
});