// message modal form
$(function() {
  var $messageForm    = $('#new_message'),
      $chatMessages   = $('#chat-messages'),
      $messageModal   = $('#message-modal');
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
      alert('Error Code: ' + xhr.status + '. Something went wrong.');
    }
  }).on('ajax:success', function () {
    var $messageInput = $messageForm.find('textarea'),
        message       = $messageInput.val();
    $messageInput.val('');

    if ($chatMessages.length > 0) {

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
      </div>').appendTo($chatMessages);
      $chatMessages.animate({
        scrollTop: $('#chat-messages').prop("scrollHeight")
      }, 1500);

    }

    if ($messageModal.length > 0) {
      $messageModal.modal('hide');
      Snackbar.show({showAction: false, text: 'Sent.'})
    }


  });
});
