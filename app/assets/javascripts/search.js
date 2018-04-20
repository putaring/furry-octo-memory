$('select#religion').change(function (e) {
  var religion = $(this).val();
  if (religion === 'hindu') {
    $('[name="sects[]"]').prop('disabled', false);
  } else {
    $('[name="sects[]"]').prop('disabled', true);
  }
});

(function () {
  // restore previous user query if localStorage is supported.
  if (window.isStorageSupported && localStorage.getItem('searchObject') !== null) {
    var searchObject = JSON.parse(localStorage.getItem('searchObject'));

    $searchForm.find('[name="gender"]').val(searchObject.gender);
    $searchForm.find('[name="min_age"]').val(searchObject.minAge);
    $searchForm.find('[name="max_age"]').val(searchObject.maxAge);
    $searchForm.find('[name="min_height"]').val(searchObject.minHeight);
    $searchForm.find('[name="max_height"]').val(searchObject.maxHeight);
    $searchForm.find('[name="religion"]').val(searchObject.religion);
    $searchForm.find('[name="languages[]"]').val(searchObject.languages);
    $searchForm.find('[name="countries[]"]').val(searchObject.countries);
    if (searchObject.religion === 'hindu') {
      $searchForm.find('[name="sects[]"]').prop('disabled', false).val(searchObject.sects);
    }

  }

})();

if ($.fn.select2) {
  $('select[multiple]').select2({
    placeholder: "Doesn't matter"
  });

  $('#search-panel').one('shown.bs.collapse', function() {
    $('select[multiple]').select2({
      placeholder: "Doesn't matter"
    });
  });
}
