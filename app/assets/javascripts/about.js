document.querySelector('#about-character-count') &&
(function() {
  var $count      = $('#about-character-count'),
      $aboutInput = $('#profile_about'),
      $btn        = $('');
  $count.text($aboutInput.val().length);

  $aboutInput.keyup(function(e) {
    $count.text($aboutInput.val().length);
  });
})();
