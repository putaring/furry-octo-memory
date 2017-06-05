// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require phone-verification/verification


var $form = $('#new_phone_verification');
var $verifyForm = $('#verify-form');

$form.find("#cell_phone").keyup(function() {
  $form.find('#phone-input')
    .removeClass('has-danger')
    .find('.form-control-feedback')
    .hide();
});
$form.find("#country").change(function() {
  $form.find('#phone-input')
    .removeClass('has-danger')
    .find('.form-control-feedback')
    .hide();
});

$form.on('ajax:error', function (e, xhr, status, error) {
  debugger;
  if (xhr.status === 429) {
    var errorHtml = "You have exceeded the number of tries. Please contact support to verify your mobile number.";
  } else if (xhr.status === 422) {
    var errorHtml = xhr.responseJSON.join('<br>');
  } else {
    var errorHtml = "Something went wrong";
  }
  $form.find('#phone-input')
    .addClass('has-danger')
    .find(".form-control-feedback")
    .html(errorHtml)
    .show();
}).on('ajax:success', function (e, data, status, xhr) {
  if (xhr.status === 201) {
    $verifyForm.attr('action', '/phone_verifications/' + data.id + '/verify');
    $('#resend-link').attr('href', '/phone_verifications/' + data.id + '/resend');
    $('#collapseOne').collapse('hide');
  }
});

$verifyForm.find("#verification_code").keyup(function() {
  $verifyForm.find('#verification-input')
    .removeClass('has-danger')
    .find('.form-control-feedback')
    .hide();
});

$verifyForm.on('ajax:error', function (e, xhr, status, error) {
  if (xhr.status === 403) {
    var errorMessage = 'Incorrect verification code';
  } else {
    var errorMessage = 'Something went wrong. Try again or contact support';
  }
  $verifyForm.find('#verification-input')
    .addClass('has-danger')
    .find(".form-control-feedback")
    .text(errorMessage)
    .show();

}).on('ajax:success', function (e, data, status, xhr) {
  if (xhr.status === 200) {
    var profileUrl = location.origin + "/users/" + data.user_id + "?welcome=true";
    $('#exit-message').html('All set! Let\'s set up your <a href="' + profileUrl + '">profile</a>.');

    $('#collapseTwo').collapse('hide');
    window.location.href = profileUrl;
  }
});

$('#collapseOne').on('show.bs.collapse', function () {
  $('#collapseTwo').collapse('hide');
}).on('hide.bs.collapse', function () {
  $('#collapseTwo').collapse('show');
});


$("#resend-link").on('ajax:success', function (e, data, status, xhr) {
  $.snackbar({
    content: "Resent",
    style: "snackbar",
    timeout: 7000
  });
}).on('ajax:error', function (e, xhr, status, error) {
  if (xhr.status === 429) {
    alert("You have exceeded the number of tries. Please contact support to verify your mobile number.")
  }
});
