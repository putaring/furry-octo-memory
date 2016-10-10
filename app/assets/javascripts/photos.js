(function () {
  var $photoForm          = $('#new_photo'),
      $photoFileInput     = $photoForm.find('#photo_image'),
      $photoImageX        = $photoForm.find('#photo_image_x'),
      $photoImageY        = $photoForm.find('#photo_image_y'),
      $photoImageWidth    = $photoForm.find('#photo_image_width'),
      $photoCanvas        = $('#photo-crop-canvas'),
      $photoPreview       = $('#photo-crop-preview'),
      $modal              = $('#photo-crop-modal'),
      reader              = new FileReader(),
      jcropApi            = null;

  $photoFileInput.click(function() {
    this.value = null;
  });
  if (true) {
    $modal.on('hide.bs.modal', function(e) {
        jcropApi.destroy();
    });

    $modal.find('.btn-primary').click(function () {
      $photoForm.submit();
      $modal.modal('hide');
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
      var file  = this.files[0];

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
          boxWidth: 600,
          boxHeight: 600,
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
  }

})();
