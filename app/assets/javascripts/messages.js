$(function() {
  var $errorAlert   = $('#message-modal-error'),
      $messageModal = $('#message-modal'),
      $messageForm  = $('#message-modal #new_message');
  $messageForm.on('ajax:error', function (e, xhr, status, error) {
    if (xhr.status === 422) {
      var list = $('<ol class="m-b-0"></ol>');
      for (var i = 0; i < xhr.responseJSON.length; i++) {
        $('<li>' + xhr.responseJSON[i] + '</li>').appendTo(list)
      }
      $errorAlert.
        empty().
        append('Please fix the error(s).').
        append(list).
        show();
    } else if (xhr.status === 401) {
      window.location = '/login'
    } else {
      $errorAlert.
        empty().
        append('Something went wrong. Try again.').
        show();
    }
  }).on('ajax:success', function () {
    $messageModal.modal('hide');
    $.snackbar({
      content: "Message sent.",
      style: "snackbar",
      timeout: 5000
    });

  }).on('ajax:before', function () {
    $errorAlert.hide();
  });

  $messageModal.on('shown.bs.modal', function () {
    $messageForm.find('textarea').focus();
  });

  $messageModal.on('hidden.bs.modal', function () {
    $errorAlert.hide();
    $messageForm.find('textarea').val('');
  });
});
