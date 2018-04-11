// message modal form
$(function() {
  var $messageForm  = $('#new_message');
  $messageForm.on('ajax:error', function (e, xhr, status, error) {
    if (xhr.status === 422) {
      var errorMessage = '';
      for (var i = 0; i < xhr.responseJSON.length; i++) {
        errorMessage = errorMessage + xhr.responseJSON[i] + '\n';
      }
      alert(errorMessage);
    } else if (xhr.status === 401) {
      window.location = '/login'
    } else {
      alert('Something went wrong');
    }
  }).on('ajax:success', function () {
    var message = $messageForm.find('textarea').val();
    $messageForm.find('textarea').val('');
    $('<div class="row justify-content-end text-right my-3">\
      <div class="col-auto">\
        <div class="card bg-primary text-white border-0">\
          <div class="card-body p-2">\
            <div>\
              ' + $.simpleFormat(message) + '\
            </div>\
            <div class="text-light">\
              <small>Just now</small>\
            </div>\
          </div>\
        </div>\
      </div>\
    </div>').appendTo('#chat-messages')
    $('#message-modal').modal('hide');
  });
});

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
