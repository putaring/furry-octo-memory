$('[type="checkbox"][data-toggle="languages"]').change(function (e) {
  if ($(this).is(":checked")) {
    $('[type="checkbox"][name="language"]').prop('checked', false);
  }
});

$('[type="checkbox"][name="language"]').change(function (e) {
  if ($(this).is(":checked")) {
    $('[type="checkbox"][data-toggle="languages"]').prop('checked', false);
  }
});
