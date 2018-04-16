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
