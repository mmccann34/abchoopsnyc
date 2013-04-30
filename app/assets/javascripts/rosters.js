$(function() {
  $('#findPlayer').dataTable({
    "sDom": "<'row'<'span8'f>r>t<'row'<'span4'i><'span4'p>>",
    "sPaginationType": "bootstrap",
    "iDisplayLength": 5,
    "bLengthChange": false,
    "aoColumnDefs": [ { "bSortable": false, "bSearchable": false, "aTargets": [ 0 ] } ],
    "aaSorting": [[2,'asc']],
    "oLanguage": { "sInfo": "Showing _START_ to _END_ of _TOTAL_ Players" }
  });
});