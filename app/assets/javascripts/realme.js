/**
 * RealMe Sign-in widget
 *
 * @param  {[type]} document    Cache the top-level document
 * @param  {[type]} window      Cache a local window object.
 * @param  {[type]} jQuery      Cache a local jQuery object.
 * @return {Object} RM          A public API to the RealMe widget.
 */
var RealMe = RealMe || (function(document, window, jQuery) {

    /**
     * Windows Phone with the mango update doesn't realise it has touchevents.
     * @type {Boolean}
     */
    var isIE9Mobile = navigator.userAgent.match(/(IEMobile\/9.0)/);
    var isIE6 = /\bMSIE 6/.test(navigator.userAgent) && !window.opera;

    if (isIE6) {
        return false;
    }

    /**
     * Internal namespace for RealMe
     * @type {Object}
     */
    var RM = {

        /**
         * Cache all our DOM elements
         * @return {void}
         */
        cacheElements: function() {
            this.$container = $('.realme_widget');
            this.$trigger = $('.whats_realme', this.$container);
            this.$modal = $('.realme_popup', this.$container);
        },

        /**
         * Called when jQuery Document is ready.
         * Simple feature detection to determine if device is touch or not
         * @return {void}
         */
        init: function() {
            /**
             * Get all the elements when we init.
             */
            this.cacheElements();
            if ('ontouchstart' in document || isIE9Mobile !== null) {
                this.$container.addClass('touch');
                this.popup_window();
            } else {
                this.$container.addClass('no_touch');
                this.bind_no_touch();
            }
        },

        /**
         * use JS to prevent the href on the <a> from being followed in case user clicks instead of just hovers
         * @return {void}
         */
        bind_no_touch: function() {
            this.$trigger.on('click', function(e){
                e.preventDefault();
            });
        },

        /**
         * [bind events for touch devices - add class to popup window to show / hide it
         * @param  {jQuery element} $elem
         * @return {void}
         */
        show_popup: function() {
            this.$modal.addClass("active");
        },

        /**
         * @param  {jQuery element} $elem
         * @return {void}
         */
        hide_popup: function() {
            this.$modal.removeClass("active");
        },

        /**
         * Popups up an information modal
         * @param  {jQuery element} $link
         * @param  {jQuery element} $modal
         * @return {void}
         */
        popup_window: function() {
            var me = this;

            this.$trigger.click(function(e){
                if (this.$modal.hasClass("active")) {
                    me.hide_popup();
                } else {
                    me.show_popup();
                }
                e.stopPropagation();
            });

            this.$trigger.click(function(){
                return false;
            });
        }
    };

    /**
     * Initialise RealMe widget
     * @return {[type]}
     */
    jQuery(document).ready(function() {
        RM.init();
    });

    return RM;

})(document, window, jQuery);
