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
      $dummyImage         = $('<img />'),
      cropWidth           = $photoForm.data('cropWidth'),
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
      if (data.files[0].size > 4000000) {
        alert('File is too large. Maximum filesize is 4 MB');
      } else {
        data.submit();
      }
    },
    progressall: function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      $progressBar.val(progress);
    },
    start: function (e) {
      $progressBar.val(0);
      $photoForm.hide();
      $progressBar.show();
    },
    done: function(e, data) {
      $progressBar.val(100);
      var url = $(data.jqXHR.responseXML).find('Location').text();
      $dummyImage.attr('src', url);
    },
    fail: function(e, data) {
      alert("Oops! Something went wrong.");
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
    $photoForm.submit();
    //$modal.modal('hide');
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

  $dummyImage.load(function () {
    var url = $(this).attr('src');
    $progressBar.val(120);

    $imageUrlField.val(url);
    $photoCanvas.attr('src', url);
    $photoPreview.attr('src', url);

    $progressBar.hide();
    $photoForm.show();

    var width       = $photoCanvas.get(0).naturalWidth,
        height      = $photoCanvas.get(0).naturalHeight,
        smallerSide = (width < height) ? width : height,
        topX        = (width/2) - (smallerSide/4),
        topY        = (height/2) - (smallerSide/4);

    if (width < 100 || height < 100) {
      alert("Please upload a bigger picture.");
    } else {
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
    }
  });

})();
