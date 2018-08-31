$(function() {
  $('[data-toggle="accept"]').on('ajax:error', function(e, xhr, status, error) {
    alert('Something went wrong. Try again');
  }).on('ajax:success', function(e, data, status, xhr) {
      $(this).replaceWith('<small class="text-success"><i class="icon ion-checkmark"></i> Accepted</small>');
  }).on('ajax:before', function () {
    $(this).addClass('disabled');
  }).on('ajax:complete', function () {
    $(this).removeClass('disabled');
  });
});
