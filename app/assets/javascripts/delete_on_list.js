(function(){
  var showListConfirmDelete = function(e) {
    e.preventDefault();

    $(this).parents('table').addClass('confirm-delete').removeClass('hide-delete');
    $(this).parents('td').addClass('actions-delete');

    $(this).siblings('.actions-delete-wrapper').find('.link-cancel').bind('click', hideListConfirmDelete);
  };

  var hideListConfirmDelete = function(e) {
    e.preventDefault();

    $(this).parents('table').removeClass('confirm-delete').addClass('hide-delete');
    $(this).parents('td').removeClass('actions-delete');

    $(this).unbind('click', hideListConfirmDelete);
  };

  $(function() {
    $('table .actions > .button-delete').bind('click', showListConfirmDelete);
  });
})();
