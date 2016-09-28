/**
 * Registration form javascripts
 */

// field validations
var validateRegistrationField = function (field) {
  if (field.checkValidity()) {
    $(field).removeClass('form-control-danger').addClass('form-control-success').
      siblings('.text-danger').text('').end().
      parent('.form-group').addClass('has-success').removeClass('has-danger');
  } else {
    var errorMessage = '';
    switch (field.id) {
      case 'user_gender':
        errorMessage = 'Pick a gender.';
        break;
      case 'user_birthdate':
        errorMessage = 'Men should be at least 21 and women, 18.';
        break;
      case 'user_religion':
        errorMessage = 'Choose your religion.';
        break;
      case 'user_language':
        errorMessage = 'Select your mother tongue.';
        break;
      case 'user_country':
        errorMessage = 'Where do you currently live.?';
        break;
      case 'user_email':
        errorMessage = 'Enter a valid email address.';
        break;
      case 'user_password':
        errorMessage = 'Create a valid password.';
        break;
      default:
        errorMessage = 'Enter valid details.'
    }
    $(field).addClass('form-control-danger').removeClass('form-control-success').
      siblings('.text-danger').text(errorMessage).end().
      parent('.form-group').addClass('has-danger').removeClass('has-success');
  }
};

var $registrationFields =  $('#new_user').find('[name^=user]:not(select[name*=birthdate])');

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

// bootstrapify rails date_select
var $birthdayDropDowns = $('select[name*=birthdate]');
$birthdayDropDowns.wrap('<div class="col-xs-4">');

$('[data-toggle="tooltip"]').tooltip()
