var PhoneVerification = function () {
  this.$phoneInputForm  = $('#new_phone_verification');
  this.$verifyForm      = $('#verify-form');
  this.$phoneNumber     = this.$phoneInputForm.find('#cell_phone');
  this.$countryCode     = this.$phoneInputForm.find('#country');
  this.$phoneInput      = this.$phoneInputForm.find('#phone_verification_phone_number');
  this.$resendLink      = $('#resend-link');
  this.$prettyNumber    = $('#international-phone-number');
  this.$code            = this.$verifyForm.find('#verification_code');
  this.init();
}

PhoneVerification.prototype = {
  init: function () {
    this.$phoneInputForm.submit($.proxy(this.validateNumber, this));

    this.$phoneInputForm.on('ajax:success', $.proxy(this.handleOTPSuccess, this));
    this.$phoneInputForm.on('ajax:error', $.proxy(this.handleOTPError, this));

    this.$verifyForm.on('ajax:success', $.proxy(this.handleVerificationSuccess, this));
    this.$verifyForm.on('ajax:error', $.proxy(this.handleVerificationError, this));

    this.$resendLink.on('ajax:error', $.proxy(this.handleOTPError, this));
    this.$resendLink.on('ajax:success', function (e, data, status, xhr) {
      $.snackbar({ content: "Resent", style: "snackbar", timeout: 7000 });
    });

    $('#collapseOne').on('show.bs.collapse', function () {
      $('#collapseTwo').collapse('hide');
    }).on('hide.bs.collapse', function () {
      $('#collapseTwo').collapse('show');
    });

  },

  handleVerificationSuccess: function(e, data, status, xhr) {
    if (xhr.status === 200) {
      var profileUrl = "/users/" + data.user_id + "?welcome=true";
      $('#exit-message').html('All set! Let\'s set up your <a href="' + profileUrl + '">profile</a>.');

      $('#collapseTwo').collapse('hide');
      window.location.href = profileUrl;
    }
  },

  handleVerificationError: function(e, xhr, status, error) {
    if (xhr.status === 403) {
      this.$code.addClass('is-invalid');
      this.$code.one('keyup', $.proxy(this.clearCodeError, this));
    } else {
      alert("Error code" + xhr.status);
    }
  },

  handleOTPSuccess: function(e, data, status, xhr) {
    if (xhr.status === 201) {
      this.$verifyForm.attr('action', '/phone_verifications/' + data.id + '/verify');
      this.$resendLink.attr('href', '/phone_verifications/' + data.id + '/resend');
      $('#collapseOne').collapse('hide');
    }
  },

  handleOTPError: function(e, xhr, status, error) {
    if (xhr.status === 429) {
      alert("You have exceeded the number of tries. Write to support@spouzz.com to verify your number.");
    } else if (xhr.status === 422) {
      alert(xhr.responseJSON.join('\n'));
    } else {
      alert("Error code" + xhr.status);
    }
  },

  validateNumber: function (e) {
    var pn = new PhoneNumber(this.$phoneNumber.val(), this.$countryCode.val());
    if (pn.isValid() && pn.isMobile()) {
      this.$phoneInput.val(pn.getNumber('e164'));
      this.$prettyNumber.html(pn.getNumber("international"));
    } else {
      this.$phoneNumber.addClass('is-invalid');
      this.$phoneNumber.one('keyup', $.proxy(this.clearPhoneError, this));
      this.$countryCode.one('change', $.proxy(this.clearPhoneError, this));
      return false;
    }
  },

  clearPhoneError: function () {
    this.$phoneNumber.removeClass('is-invalid');
  },

  clearCodeError: function () {
    this.$code.removeClass('is-invalid');
  }
}

new PhoneVerification();
