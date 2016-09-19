$(function() {
  $('#message-modal').on('ajax:error', function (e, xhr, status, error) {
    if (xhr.status === 422) {
      var list = $('<ol class="m-b-0"></ol>');
      for (var i = 0; i < xhr.responseJSON.length; i++) {
        $('<li>' + xhr.responseJSON[i] + '</li>').appendTo(list)
      }
      $('#message-modal-error').
      empty().
      append('Please fix the following error(s).').
      append(list).
      show();
    } else if (xhr.status === 401) {
      window.location = '/login'
    } else {
      $('#message-modal-error').
      empty().
      append('Something went wrong. Try again.').
      show();
    }
  }).on('ajax:success', function () {

  }).on('ajax:before', function () {
    $('#message-modal-error').hide();
  });
});
