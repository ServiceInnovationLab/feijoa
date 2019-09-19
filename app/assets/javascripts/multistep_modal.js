// adapted from https://github.com/ngzhian/multi-step-modal
'use strict';

var initializeModals = function(selector){
  var modals = $(selector);
  modals.each(function(idx, modal) {
    console.log(modal)
    var $modal = $(modal);
    var $bodies = $modal.find('div.modal-body');
    var reset_on_close = $modal.attr('reset-on-close') === 'true';

    function reset() {
      $modal.find('.step').hide();
      $modal.find('[data-step]').hide();
    }

    function goToStep(step) {
      reset();
      var to_show = $modal.find('.step-' + step);
      if (to_show.length === 0) {
        // at the last step, nothing else to show
        return;
      }
      to_show.show();
      var current = parseInt(step, 10);
    }

    $modal.find('[data-trigger]').on('click', function(){
      goToStep($(this).data('trigger'));
    })

    function initialize() {
      reset();
      $modal.find('.step-1').show();
      if (reset_on_close){
        $modal.on('hidden.bs.modal', function () {
          reset();
          $modal.find('.step-1').show();
        })
      }
    }

    initialize();
  })
}
