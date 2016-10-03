// **Example Usage**
// $.simpleFormat("this is first \n here is next line")
// OR
// $(".note").simpleFormat()

(function($) {
  $.simpleFormat = function(str) {
    str = str.replace(/\r\n?/, "\n");
    str = $.trim(str);
    if (str.length > 0) {
      str = str.replace(/\n\n+/g, "</p><p>");
      str = str.replace(/\n/g, "<br />");
      str = "<p>" + str + "</p>";
    }
    return str;
  };

  $.fn.simpleFormat = function() {
    return this.html($.simpleFormat(this.html()));
  };

})(jQuery);
