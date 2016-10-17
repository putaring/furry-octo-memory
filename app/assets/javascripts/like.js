$(function() {
  var $likeBtn = $('.user-like-btn');
  $likeBtn.on('ajax:error', function (e, xhr, status, error) {
    alert('Something went wrong. Refresh and try again');
  }).on('ajax:success', function (e, data, status, xhr) {
    if (xhr.status === 201) {
      // liked
      $.snackbar({
        content: "Liked.",
        style: "snackbar",
        timeout: 5000
      });
      $(this).text('Unlike').
        data('method', 'delete');
    } else {
      // unliked
      $.snackbar({
        content: "Unliked",
        style: "snackbar",
        timeout: 5000
      });
      $(this).text($(this).data('likeText') || 'Like').
        data('method', 'post');
    }
  }).on('ajax:before', function () {
    $(this).addClass('disabled');
  }).on('ajax:complete', function () {
    $(this).removeClass('disabled');
  });
});
