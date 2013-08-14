$(function() {
  $.fn.dataTableExt.afnSortData['dom-text'] = function  ( oSettings, iColumn )
  {
    return $.map( oSettings.oApi._fnGetTrNodes(oSettings), function (tr, i) {
      return $('td:eq('+iColumn+') input', tr).val();
    } );
  }
  
  $('#teams').dataTable({
    "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "iDisplayLength": 25,
    "aoColumnDefs": [ { "bSortable": false, "bSearchable": false, "aTargets": [ 0, 1 ] } ],
    "aoColumns": [
			null,
			null,
			{ "sSortDataType": "dom-text" },
			{ "sSortDataType": "dom-text" }
		],
    "aaSorting": [[2,'asc']],
    "oLanguage": { "sInfo": "Showing _START_ to _END_ of _TOTAL_ Teams" }
  });
});