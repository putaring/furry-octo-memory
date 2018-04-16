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
  note: "Selfie? Picture with friends and family? Varying up your photos helps people see more of who you are and what you like to do.",
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
