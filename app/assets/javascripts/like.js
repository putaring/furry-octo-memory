$(function() {
  var $likeBtn      = $('[data-component="likeButton"]'),
      $declineBtn   = $('[data-component="declineButton"]');
  $likeBtn.on('ajax:error', function (e, xhr, status, error) {
    alert('Something went wrong. Refresh and try again');
  }).on('ajax:success', function (e, data, status, xhr) {
    if (xhr.status === 201) {
      // liked
      $.snackbar({
        content: "Awesome. We'll let them know",
        style: "snackbar",
        timeout: 7000
      });
      $(this).text('Unlike').
        data('method', 'delete');
    } else {
      // unliked
      $.snackbar({
        content: "Unliked",
        style: "snackbar",
        timeout: 7000
      });
      $(this).text($(this).data('likeText') || 'Like').
        data('method', 'post');
    }
  }).on('ajax:before', function () {
    $(this).addClass('disabled');
  }).on('ajax:complete', function () {
    $(this).removeClass('disabled');
  });

  $declineBtn.on('ajax:error', function (e, xhr, status, error) {
    alert('Something went wrong. Refresh and try again');
  }).on('ajax:success', function (e, data, status, xhr) {
    if (xhr.status === 204) {
      $.snackbar({
        content: "Deleted. You can always change your mind later",
        style: "snackbar",
        timeout: 7000
      });
      $(this).parents('.media').css('background-color', '#ECEFF1').slideUp('slow');
    } else {
      alert('Something went wrong. Refresh and try again');
    }
  }).on('ajax:before', function () {
    $(this).addClass('disabled');
  }).on('ajax:complete', function () {
    $(this).removeClass('disabled');
  });
});
