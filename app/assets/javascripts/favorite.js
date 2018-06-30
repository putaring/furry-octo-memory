$(function() {
  var $favoriteLink = $('[data-component="favoriteLink"]');
  $favoriteLink.on('ajax:error', function (e, xhr, status, error) {
    alert('Something went wrong. Refresh and try again');
  }).on('ajax:success', function (e, data, status, xhr) {
    if (xhr.status === 201) {
      // favorited
      $(this).text('Remove from favorites').
        data('method', 'delete');
    } else {
      // unfavorited
      $(this).text('Add to favorites').
        data('method', 'post');
      $(this).parents('.card').slideUp();
    }
  }).on('ajax:before', function (e) {
    var linkText =  ($(e.target).data('method') === "post") ? "Adding…" : "Removing…";

    $(this).
      text(linkText).
      addClass('disabled');

  }).on('ajax:complete', function () {
    $(this).removeClass('disabled');
  });

});
