$(function() {
  $('[data-behavior~=datepicker]').datepicker({
    "autoclose": true,
    "startDate": "01/01/2011",
    "assumeNearbyYear": 20,
  })
});