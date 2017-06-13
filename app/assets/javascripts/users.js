/**
 * Registration form javascripts
 */

// field validations
var validateRegistrationField = function (field) {
  if (field.checkValidity()) {
    $(field).removeClass('form-control-danger').addClass('form-control-success').
      siblings('.text-danger').text('').end().
      parent('.form-group').addClass('has-success').removeClass('has-danger');

    if(field.id == 'user_height') {
      var height  = $(field).val(),
          gender  = $('#user_gender').val();
      if (gender === 'm' && (height > 72 && height <= 75 )) {
        $(field).siblings('.text-success').text('Whoa! Hey there handsome ;-)').show();
      } else if (gender === 'm' && (height <= 72 && height >= 70 )) {
        $(field).siblings('.text-success').text('Ah! Perfect.').show();
      } else if (gender === 'f' && (height >= 67 && height <= 70 )) {
        $(field).siblings('.text-success').text('Whoa! Hey there gorgeous ;-)').show();
      } else if (gender === 'f' && (height >= 53 && height < 60 )) {
        $(field).siblings('.text-success').text('Good things come in small packages :-)').show();
      } else {
        $(field).siblings('.text-success').hide();
      }
    }

  } else {
    var errorMessage = '';
    switch (field.id) {
      case 'user_gender':
        errorMessage = 'Pick a gender.';
        break;
      case 'user_birthdate':
        errorMessage = 'Enter your birthdate.';
        break;
      case 'user_height':
        errorMessage = 'Enter your height.';
        $(field).siblings('.text-success').hide();
        break;
      case 'user_religion':
        errorMessage = 'Choose your religion.';
        break;
      case 'user_language':
        errorMessage = 'Pick a language.';
        break;
      case 'user_country':
        errorMessage = 'Where do you currently live?';
        break;
      case 'status':
        errorMessage = 'Select your marital status';
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

$('#user_religion').change(function () {
  if ($(this).val() === 'hindu') {
    $('#caste-selection-container').slideDown();
    $('#user_sect').prop('disabled', false);
  } else {
    $('#user_sect').prop('disabled', true);
    $('#caste-selection-container').slideUp()
  }
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

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})
