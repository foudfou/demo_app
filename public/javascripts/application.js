// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Event.observe(window, 'load', function() {

//     Event.observe('micropost_content', 'keyup', textChanged);
//     Event.observe('micropost_content', 'keydown', textChanged);
//     function textChanged() {
//         var maxLen = 140;
//         var left = maxLen - this.getValue().length;
//         $('char-count').update(left);
//     }

// });

$(document).ready(function () {

    $('#micropost_content').live('paste keyup keydown', function(e) {
        var maxLen = $(this).attr('maxlength');
        var left = maxLen - $(this).val().length;
        $('#char-count').html(left);
    });

});
