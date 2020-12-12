$(document).on('turbolinks:load', function(){
  $('.comments').on('click', '.edit_comment_link', function(e) {
    e.preventDefault();
    $(this).hide();
    var commentId = $(this).data('commentId');
    $('form#edit_comment_' + commentId).show();
  })
});
