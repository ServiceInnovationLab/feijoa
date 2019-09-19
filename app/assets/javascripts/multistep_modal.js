// adapted from https://github.com/ngzhian/multi-step-modal
'use strict';

function initializeModals(selector){
  var modals = $(selector);
  modals.each(function(idx, modal) {
    var $modal = $(modal);

    function reset() {
      $modal.find('.step').hide();
      $modal.find('[data-step]').hide();
    }

    function goToStep(step) {
      reset();
      var to_show = $modal.find('.step-' + step);
      if (to_show.length !== 0) { to_show.show(); }
    }

    $modal.find('[data-trigger]').on('click', function(){
      goToStep($(this).data('trigger'));
    })

    function initialize() {
      reset();
      $modal.find('.step-1').show();
      $modal.on('hidden.bs.modal', function () {
        reset();
        $modal.find('.step-1').show();
      })
    }

    initialize();
  })
}
