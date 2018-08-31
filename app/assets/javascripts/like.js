$(function() {
  $('[data-toggle="like"]').on('ajax:error', function(e, xhr, status, error) {
    alert('Something went wrong. Try again');
  }).on('ajax:success', function(e, data, status, xhr) {
    if (xhr.status === 201) {
      $(this).html('<i class="icon ion-close"></i> Unlike').
        removeClass('btn-pink').
        addClass('btn-outline-pink').
        data('method', 'delete');
    } else {
      $(this).text('Like').
        addClass('btn-pink').
        removeClass('btn-outline-pink').
        data('method', 'post');
    }
  }).on('ajax:before', function () {
    $(this).addClass('disabled');
  }).on('ajax:complete', function () {
    $(this).removeClass('disabled');
  });
});
