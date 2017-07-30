(function () {
  var InactivePhoto = function (elem) {
    this.$elem  = $(elem);
    this.id     = this.$elem.data('photoId');
    this.photo  = null;
    this.tries  = 0;
  };

  InactivePhoto.prototype = {
    process: function () {
      this.tries += 1;

      if (this.tries <= 5) {
        // we only poll 5 times. We dont want to keep polling for the photo
        // in case something went wrong
        window.setTimeout($.proxy(this.getPhoto, this), 10000);
      }
    },

    getPhoto: function () {
      var url = '/photos/' + this.id;
      $.getJSON(url, $.proxy(this.setProcessedPhoto, this));
    },

    setProcessedPhoto: function (photo) {
      if (photo.status === "active") {
        this.photo = photo;
        this.updatePhoto()
      } else {
        this.process();
      }
    },

    updatePhoto: function () {
      var isProfilePhoto = this.photo.rank == 1;
      if (isProfilePhoto) {
        var newPhotoHtml = '<a data-toggle="swipebox" href="' + this.photo.image.url + '">\
                              <img class="card-img-top img-fluid w-100" src="' + this.photo.image.thumb.url + '" />\
                            </a>\
                            <div class="card-block">\
                              <p class="card-text text-center" style="min-height: 50px;">\
                                <button class="btn btn-sm btn-outline-primary btn-block" disabled>Profile photo</button>\
                                <a class="btn btn-sm btn-block btn-outline-secondary" data-confirm="Delete picture?" data-component="deletePhotoLink" data-disable-with="Deleting…" data-remote="true" rel="nofollow" data-method="delete" href="/photos/' + this.id + '">Delete</a>\
                              </p>\
                            </div>';
      } else {
        var newPhotoHtml = '<a data-toggle="swipebox" href="' + this.photo.image.url + '">\
                              <img class="card-img-top img-fluid w-100" src="' + this.photo.image.thumb.url + '" />\
                            </a>\
                            <div class="card-block">\
                              <p class="card-text text-center" style="min-height: 50px;">\
                                <a class="btn btn-sm btn-outline-primary btn-block" data-confirm="Do you want to make this your profile picture?" data-disable-with="okey-dokey…" rel="nofollow" data-method="patch" href="/photos/' + this.id + '/make-profile-photo">Make profile photo</a>\
                                <a class="btn btn-sm btn-block btn-outline-secondary" data-confirm="Delete picture?" data-component="deletePhotoLink" data-disable-with="Deleting…" data-remote="true" rel="nofollow" data-method="delete" href="/photos/' + this.id + '">Delete</a>\
                              </p>\
                            </div>';
      }
      this.$elem.html(newPhotoHtml);
      $('.alert.alert-info').text('Your photo is ready. You look great. 👍');
    }
  };

  $('[data-component="inactive-photo"]').each(function() {
    (new InactivePhoto(this).process());
  });

}());
