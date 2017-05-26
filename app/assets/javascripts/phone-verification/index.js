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

}).on('ajax:success', function (e, data, status, xhr) {
  if (xhr.status === 201) {
    $('#collapseOne').collapse('hide');
  }
});

$('#collapseOne').on('show.bs.collapse', function () {
  $('#collapseTwo').collapse('hide');
}).on('hide.bs.collapse', function () {
  $('#collapseTwo').collapse('show');
});
