var $topNav   = $('.navbar.fixed-top');
var $document = $(document);
$document.scroll(function() {
  if ($document.scrollTop() >= 10) {
     $topNav.addClass('box-shadow');
   } else {
     $topNav.removeClass('box-shadow');
   }
})
