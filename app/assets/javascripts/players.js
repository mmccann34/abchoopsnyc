$(function() {
  $('#players').dataTable({
    "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "iDisplayLength": 25,
    "aoColumnDefs": [ { "bSortable": false, "bSearchable": false, "aTargets": [ 0, 1 ] } ],
    "aaSorting": [[3,'asc']],
    "oLanguage": { "sInfo": "Showing _START_ to _END_ of _TOTAL_ Players" },
    "bPaginate": false
  });
});