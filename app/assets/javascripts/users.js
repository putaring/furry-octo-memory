var validateRegistrationField = function (field) {
  if (field.checkValidity()) {
    $(field).removeClass('form-control-danger').addClass('form-control-success').
      siblings('.text-danger').text('').end().
      parent('.form-group').addClass('has-success').removeClass('has-danger');
  } else {
    $(field).addClass('form-control-danger').removeClass('form-control-success').
      siblings('.text-danger').text(field.validationMessage).end().
      parent('.form-group').addClass('has-danger').removeClass('has-success');
  }
};

var $registrationFields =  $('#new_user').find('[name^=user]');

$registrationFields.on('change focusout', function (e) {
  validateRegistrationField(this);
});

$('#new_user').submit(function (e) {
  if (this.checkValidity() === false) {
    $registrationFields.each(function (index, el) {
      validateRegistrationField(this);
    });
    e.preventDefault();
    return false;
  }
});
