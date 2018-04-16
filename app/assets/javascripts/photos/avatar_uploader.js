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
  trigger: '[data-toggle="avatar-uploader"]',
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
