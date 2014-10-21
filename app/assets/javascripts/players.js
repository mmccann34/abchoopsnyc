$(function() {
  $('#players').dataTable({
    "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "iDisplayLength": 25,
 //   "bLengthChange": false,
    "aoColumnDefs": [ { "bSortable": false, "bSearchable": false, "aTargets": [ 0 ] } ],
    "aaSorting": [[2,'asc']],
    "oLanguage": { "sInfo": "Showing _START_ to _END_ of _TOTAL_ Players" },
    "bServerSide": true,
    "sAjaxSource": $('#players').data('source'),
    "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
      $(nRow).attr("onclick", "document.location = '/admin/players/" + aData[10] + "';");
    }
  });
  
  $('#merge-players').dataTable({
    "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "iDisplayLength": 25,
 //   "bLengthChange": false,
    "aoColumnDefs": [ { "bSortable": false, "bSearchable": false, "aTargets": [ 0 ] } ],
    "aaSorting": [[2,'asc']],
    "oLanguage": { "sInfo": "Showing _START_ to _END_ of _TOTAL_ Players" },
    "bServerSide": true,
    "sAjaxSource": $('#merge-players').data('source'),
    "fnServerParams": function ( aoData ) {
      aoData.push({ name: "merge", value: true });
    }
  });
  
  $('#merge-duplicates').dataTable({
    "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "iDisplayLength": 25,
 //   "bLengthChange": false,
    "aoColumnDefs": [ { "bSortable": false, "bSearchable": false, "aTargets": [ 0 ] } ],
    "aaSorting": [[2,'asc']],
    "oLanguage": { "sInfo": "Showing _START_ to _END_ of _TOTAL_ Players" },
    "bServerSide": true,
    "sAjaxSource": $('#merge-duplicates').data('source'),
    "fnServerParams": function ( aoData ) {
      aoData.push({ name: "merge_duplicates", value: true });
    }
  });
  
  $('#add_social_media').click(addSocialMedia);
});

function addSocialMedia() {
  var i = 1;
  while ($('#social_media_' + i).length) {
    i++;
  }
  
  $('#social_media_1').clone().attr({
    id: "social_media_" + i,
    name: "social_media[" + i + "]"
  }).val('facebook').appendTo('#social_media_urls');
  
  $('#social_media_values_1').clone().attr({
    id: "social_media_values_" + i,
    name: "social_media_values[" + i + "]"
  }).val('').appendTo('#social_media_urls');
}