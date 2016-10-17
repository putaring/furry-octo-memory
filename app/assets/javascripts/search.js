$('[type="checkbox"][data-toggle="languages"]').change(function (e) {
  if ($(this).is(":checked")) {
    $('[type="checkbox"][name="languages[]"]').
    prop('checked', false);
  }
});

$('[type="checkbox"][name="languages[]"]').change(function (e) {
  if ($(this).is(":checked")) {
    $('[type="checkbox"][data-toggle="languages"]').prop('checked', false);
  }
});

$('[type="checkbox"][data-toggle="countries"]').change(function (e) {
  if ($(this).is(":checked")) {
    $('[type="checkbox"][name="countries[]"]').
    prop('checked', false);
  }
});

$('[type="checkbox"][name="countries[]"]').change(function (e) {
  if ($(this).is(":checked")) {
    $('[type="checkbox"][data-toggle="countries"]').prop('checked', false);
  }
});
