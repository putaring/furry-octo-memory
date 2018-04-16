var AvatarLoader = function (el) {
  this.$messageContainer = $(el);
}

AvatarLoader.prototype = {
  loadAvatar: function () {
     window.setTimeout($.proxy(this.getAvatar, this), 1000);
  },

  getAvatar: function () {
    $.getJSON('/avatar', $.proxy(this.setAvatar, this));
  },

  setAvatar: function (data, status, xhr) {
    if (xhr.status == 200) {
      $('[data-toggle="avatar-photo"]').attr('src', data.url);
      this.$messageContainer.html('<i class="icon ion-edit mr-1"></i> Change photo');
    } else if (xhr.status == 202) {
      this.loadAvatar();
    } else {
      ;
    }
  }
}

$(function() {
  $('[data-toggle="avatar-loader"]').each(function() {
    var avatarLoader = new AvatarLoader(this);
    avatarLoader.loadAvatar();
  });
})
