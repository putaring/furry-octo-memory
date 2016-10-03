$('#older-messages-btn').click(function (e) {
  e.preventDefault();
  $(this).remove();
  $('.media:hidden').slideDown();
})
