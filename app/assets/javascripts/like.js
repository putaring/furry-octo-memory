$(function() {
  var $likeBtn = $('#profile-like-btn');
  $likeBtn.on('ajax:error', function (e, xhr, status, error) {
    alert('Something went wrong. Refresh page and try again.');
  }).on('ajax:success', function (e, data, status, xhr) {
    if (xhr.status === 201) {
      // liked
      $.snackbar({
        content: "Liked. They'll be notified. Yay!",
        style: "snackbar",
        timeout: 5000
      });
      $likeBtn.text('Unlike').removeClass('btn-accent').addClass('btn-outline-accent').data('method', 'delete');

    } else {
      // unliked
      $.snackbar({
        content: "Unliked.",
        style: "snackbar",
        timeout: 5000
      });
      $likeBtn.text('Like').addClass('btn-accent').removeClass('btn-outline-accent').data('method', 'post');

    }
  }).on('ajax:before', function () {
    $likeBtn.addClass('disabled');
  }).on('ajax:complete', function () {
    $likeBtn.removeClass('disabled');
  });
});
