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

$('[type="checkbox"][data-toggle="countries"]').change(function (e) {
  if ($(this).is(":checked")) {
    $('[type="checkbox"][name="country"]').prop('checked', false);
  }
});

$('[type="checkbox"][name="country"]').change(function (e) {
  if ($(this).is(":checked")) {
    $('[type="checkbox"][data-toggle="countries"]').prop('checked', false);
  }
});
