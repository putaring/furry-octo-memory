(function () {
  var $photoForm          = $('#new_photo'),
      $photoFileInput     = $photoForm.find('#photo_image'),
      $photoCanvas        = $('#photo-crop-canvas'),
      $photoPreview       = $('#photo-crop-preview'),
      $progressBar        = $('#s3-upload-progress'),
      $modal              = $('#photo-crop-modal'),
      cropWidth           = $photoForm.data('cropWidth'),
      $progressText       = $('#progress-text'),
      jcropApi            = null,
      cropDimensions      = {};

  $photoFileInput.fileupload({
    add: function (e, data) {
      data.context = $('body').on('crop.finished', function () {
        $.getJSON("/presign", function(result) {
          data.formData  = result.fields;
          data.url       = result.url;
          data.paramName = "file";
          data.submit();
        });
      });
    },
    progressall: function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      $progressBar.css({
        width: progress + '%'
      });
      if(progress >= 50) {
        $progressText.text('Saving…');
      }
    },
    start: function (e) {
      $progressBar.css({
        width: '0%'
      });
      $progressText.show().text('Adding photo…');
      $photoForm.hide();
      $progressBar.show();
    },
    done: function(e, data) {
      $progressBar.css({
        width: '100%'
      });
      $progressText.text("Hang in there… We're almost done.");

      var image = {
        id: data.formData.key.match(/cache\/(.+)/)[1], // we have to remove the prefix part
        storage: 'cache',
        cropDimensions: cropDimensions
      };
      $photoForm.find('#cahced-image-data').val(JSON.stringify(image))
      $photoFileInput.val(null);
      $photoForm.submit();
    },
    fail: function(e, data) {
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
    cropDimensions = {
      offsetX: coords.x,
      offsetY: coords.y,
      width: coords.w
    }

    $photoPreview.css({
      width: Math.round(150/coords.w * $photoCanvas.width()) + 'px',
      height: Math.round(150/coords.h * $photoCanvas.height()) + 'px',
      marginLeft: '-' + Math.round(150/coords.w * coords.x) + 'px',
      marginTop: '-' + Math.round(150/coords.w * coords.y) + 'px'
    })
  };

  var addPhotoToCanvas = function () {
    $photoCanvas.attr('src', this.result);
    $photoPreview.attr('src', this.result);
    $photoCanvas.load(setupJcrop);
  };

  var setupJcrop = function () {

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

    $modal.modal({
      backdrop: 'static',
      keyboard: false
    });
  };


  $photoFileInput.change(function(e) {
    var file    = this.files[0],
        reader  = new FileReader();

    if(!(/image\//).test(file.type)) {
      alert("We couldn't read the file you added. Please upload an image and try again.");
      return;
    }

    reader.addEventListener("load", addPhotoToCanvas, false);

    if (file) {
      reader.readAsDataURL(file);
    }
  });

})();
