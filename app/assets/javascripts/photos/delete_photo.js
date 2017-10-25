$(function() {
  $('body').on('ajax:error', '[data-component="deletePhotoLink"]', function () {
    alert('Oops! something went wrong. Reload the page and try again');
  }).on('ajax:success', '[data-component="deletePhotoLink"]', function () {
    $(this).parents('.col-md-4').slideUp();
    $.snackbar({
      content: "Deleted.",
      style: "snackbar",
      timeout: 7000
    });
    $('.alert.alert-info').text('Deleted')
  }).on('ajax:before', '[data-component="deletePhotoLink"]', function () {
    $(this).addClass('disabled');
  }).on('ajax:complete', '[data-component="deletePhotoLink"]', function () {
    $(this).removeClass('disabled');
  });;
});