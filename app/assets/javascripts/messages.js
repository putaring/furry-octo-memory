// message modal form
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

if (location.search.match(/message_dialog=true/)) {
  $('#message-modal').modal('show');
  history.replaceState(null, null, location.pathname)
}

// message form for conversation
$(function() {
  var $messageForm  = $('[data-form-type="conversation-form"]');
  $messageForm.on('ajax:error', function (e, xhr, status, error) {
    if (xhr.status === 422) {
      var errors = '';
      for (var i = 0; i < xhr.responseJSON.length; i++) {
        errors += xhr.responseJSON[i] + '\n';
      }
      alert(errors);
    } else if (xhr.status === 401) {
      window.location = '/login'
    } else {
      alert('Error code: ' + xhr.status + '. Something went wrong.');
    }
  }).on('ajax:success', function (event, data, status, xhr) {
    $messageForm.find('textarea').val('');

    var messageNode = $('<div class="media mb-3">\
      <div>\
        <a href="/users/' + $messageForm.data('user').id + '">\
          <img src="' + $messageForm.data('user').photo + '" class="rounded-circle mr-3" width="70" />\
        </a>\
      </div>\
      <div class="media-body p-3" style="background-color:#E8F5E9;color:#5e6573">\
        ' + $.simpleFormat(data.body) + '\
        <small class="text-muted">Sent just now</small>\
      </div>\
    <div>');

    $messageForm.closest('.media').before(messageNode);

    $.snackbar({
      content: "Message sent",
      style: "snackbar",
      timeout: 5000
    });
  });
});
