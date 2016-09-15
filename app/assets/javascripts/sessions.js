$(function() {
  $('#login-form').on('ajax:error', function () {
    $('#login-modal-error').show();
  }).on('ajax:success', function () {
    window.location.reload(true)
  }).on('ajax:before', function () {
    $('#login-modal-error').hide();
  });
});
