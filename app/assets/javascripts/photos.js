$('[data-component="photo-caption-container"]').click(function(e) {
  var photoId         = $(e.currentTarget).data('photoId'),
      $metaContainer  = $("#photo-meta-container-" + photoId),
      $captionForm    = $("#edit_photo_" + photoId);
  $captionForm.removeClass('d-none').addClass('d-block');
  $metaContainer.addClass('d-none').removeClass('d-block');
});

$('[data-component="photo-caption-cancel"]').click(function(e) {
  var photoId         = $(e.currentTarget).data('photoId'),
      $metaContainer  = $("#photo-meta-container-" + photoId),
      $captionForm    = $("#edit_photo_" + photoId);
  $metaContainer.removeClass('d-none').addClass('d-block');
  $captionForm.addClass('d-none').removeClass('d-block');
});

var albumUploader = Uppy.Core({
  autoProceed: true,
  restrictions: {
    maxFileSize: 5000000,
    maxNumberOfFiles: 1,
    minNumberOfFiles: 1,
    allowedFileTypes: ['image/*']
  }
});

albumUploader.use(Uppy.Dashboard, {
  trigger: '#add-a-photo',
  note: "Selfie? Picture with friends and family? We love them all 🎉. You can add a caption later.",
  locale: {
    strings: {
      dropPaste: 'Drop your photo here or'
    }
  }
});

albumUploader.use(Uppy.AwsS3, {
  getUploadParameters: function(file) {
    return fetch('/presign?filename=' + encodeURIComponent(file.name))
        .then(function (response) {
          return response.json();
        });
  }
});

albumUploader.on("upload-success", function (file, data) {
  var uploadedFileData = JSON.stringify({
    id: file.meta['key'].match(/^cache\/(.+)/)[1],
    storage: 'cache'
  });
  $('#new_photo')
    .find('#photo_image')
    .val(uploadedFileData)
    .end()
    .submit();
});

albumUploader.run();

var avatarUploader = Uppy.Core({
  autoProceed: true,
  restrictions: {
    maxFileSize: 5000000,
    maxNumberOfFiles: 1,
    minNumberOfFiles: 1,
    allowedFileTypes: ['image/*']
  }
});

avatarUploader.use(Uppy.Dashboard, {
  trigger: '[data-component="avatar-uploader"]',
  note: "Add your picture. You'll be asked to crop it in the next step.",
  locale: {
    strings: {
      dropPaste: 'Drop your photo here or'
    }
  }
});

avatarUploader.use(Uppy.AwsS3, {
  getUploadParameters: function(file) {
    return fetch('/presign?filename=' + encodeURIComponent(file.name))
        .then(function (response) {
          return response.json();
        });
  }
});

avatarUploader.on("upload-success", function (file, data) {
  var photoKey = file.meta['key'].match(/^cache\/(.+)/)[1];
  window.location.href = '/avatar/crop?cached_object_key=' + encodeURIComponent(photoKey);
});
