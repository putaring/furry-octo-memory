$(function() {
  $('form.edit_user,form.edit_profile').on('ajax:error', function (e, xhr, status, error) {
    if (xhr.status === 422) {
      var list = $('<ol class="m-b-0"></ol>');
      for (var i = 0; i < xhr.responseJSON.length; i++) {
        $('<li>' + xhr.responseJSON[i] + '</li>').appendTo(list)
      }
      $(this).find('.edit_errors').
        empty().
        append('Please fix the error(s).').
        append(list).
        show();
    } else if (xhr.status === 401) {
      window.location = '/login'
    } else if (xhr.status === 403) {
      $(this).find('.edit_user_errors').
        empty().
        append('Permission denied.').
        show();
    } else {
      $(this).find('.edit_errors').
        empty().
        append('Something went wrong. Try again.').
        show();
    }
  }).on('ajax:success', function () {
    if (location.pathname.match(/\/users\//)) {
      // if the user is updating information from their profile page, then reload page
      location.reload(true);
    } else {
      $.snackbar({
        content: "Updated. <strong><a href='/users/" + $(this).data('userId') + "'>VIEW PROFILE</a></strong>",
        style: "snackbar",
        htmlAllowed: true,
        timeout: 5000
      });
    }
  }).on('ajax:before', function () {
    $(this).find('.edit_errors').hide();
    $(this).find('.edit_success').hide();
  });
});
