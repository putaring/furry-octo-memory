(function () {
  var $photoForm          = $('#new_photo'),
      $photoFileInput     = $photoForm.find('#photo_image'),
      $photoImageX        = $photoForm.find('#photo_image_x'),
      $photoImageY        = $photoForm.find('#photo_image_y'),
      $photoImageWidth    = $photoForm.find('#photo_image_width'),
      $imageUrlField      = $photoForm.find('#photo_remote_image_url'),
      $photoCanvas        = $('#photo-crop-canvas'),
      $photoPreview       = $('#photo-crop-preview'),
      $progressBar        = $('#s3-upload-progress'),
      $modal              = $('#photo-crop-modal'),
      cropWidth           = $photoForm.data('cropWidth'),
      $progressText       = $('#progress-text'),
      jcropApi            = null;

  $photoFileInput.fileupload({
    fileInput: $photoFileInput,
    url: $photoForm.data('url'),
    type: 'POST',
    autoUpload: true,
    formData: $photoForm.data('formData'),
    paramName: 'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
    dataType:  'XML',  // S3 returns XML if success_action_status is set to 201
    replaceFileInput: false,
    add: function (e, data) {
      data.context = $('body').on('crop.finished', function () {
        data.submit();
      });
    },
    progressall: function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      $progressBar.val(progress);
      if(progress >= 50) {
        $progressText.text('Saving…');
      }
    },
    start: function (e) {
      $progressBar.val(0);
      $progressText.show().text('Processing request…');
      $photoForm.hide();
      $progressBar.show();
    },
    done: function(e, data) {
      $progressBar.val(100);
      $progressText.text('Hang in there…');
      var url = data.url + '/' + $(data.jqXHR.responseXML).find('Key').text();
      $imageUrlField.val(url);
      $photoFileInput.val(null);
      $photoForm.submit();
    },
    fail: function(e, data) {
      alert("Oops! Something went wrong.");
      $progressBar.hide();
      $photoForm.show();
      $progressBar.hide();
    }
  });

  $photoFileInput.click(function() {
    this.value = null;
  });

  $modal.on('hide.bs.modal', function(e) {
      jcropApi.destroy();
  });

  $modal.find('.btn-primary').click(function () {
    $(this).text('Uploading…').prop('disabled', true);
    $photoFileInput.val(null);
    //$photoForm.submit();
    $modal.modal('hide');
    $('body').trigger('crop.finished');
  });

  var setCoordinates = function (coords) {
    $photoImageX.val(coords.x);
    $photoImageY.val(coords.y);
    $photoImageWidth.val(coords.w);

    $photoPreview.css({
      width: Math.round(150/coords.w * $photoCanvas.width()) + 'px',
      height: Math.round(150/coords.h * $photoCanvas.height()) + 'px',
      marginLeft: '-' + Math.round(150/coords.w * coords.x) + 'px',
      marginTop: '-' + Math.round(150/coords.w * coords.y) + 'px'
    })
  };


  $photoFileInput.change(function(e) {
    var file    = this.files[0],
        reader  = new FileReader();

    reader.addEventListener("load", function () {
      $photoCanvas.attr('src', reader.result);
      $photoPreview.attr('src', reader.result);

      var width       = $photoCanvas.get(0).naturalWidth,
          height      = $photoCanvas.get(0).naturalHeight,
          smallerSide = (width < height) ? width : height,
          topX        = (width/2) - (smallerSide/4),
          topY        = (height/2) - (smallerSide/4);

      $photoCanvas.Jcrop({
        onSelect: setCoordinates,
        onChange: setCoordinates,
        boxWidth: cropWidth,
        boxHeight: cropWidth,
        keySupport: false,
        aspectRatio: 1,
        bgOpacity: .4,
        minSize: [100, 100],
        setSelect: [topX, topY, topX + (smallerSide/2), topY]
      }, function () {
        jcropApi = this;
      });

      $modal.modal();

    }, false);

    if (file) {
      reader.readAsDataURL(file);
    }
  });

})();
