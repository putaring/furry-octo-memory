$(function() {
  $('[data-toggle="decline"]').on('ajax:error', function(e, xhr, status, error) {
    alert('Something went wrong. Try again');
  }).on('ajax:success', function(e, data, status, xhr) {
      $(this).parents('p').html('<small class="text-danger"><i class="icon ion-close"></i> Declined</small>');
  }).on('ajax:before', function () {
    $(this).addClass('disabled');
  }).on('ajax:complete', function () {
    $(this).removeClass('disabled');
  });
});
