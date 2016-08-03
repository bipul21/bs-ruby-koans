/* global Tinycon:false, ansi_up:false */

window.App = (function (window, document) {
    'use strict';

    /**
     * @type {Object}
     * @private
     */
    var _socket;

    /**
     * @type {HTMLElement}
     * @private
     */
    var _logContainer;

    /**
     * @type {HTMLElement}
     * @private
     */
    var _filterInput;



    /**
     * @type {HTMLElement}
     * @private
     */
    var _topbar;

    /**
     * @type {HTMLElement}
     * @private
     */
    var _body;

    /**
     * @type {number}
     * @private
     */
    var _linesLimit = Math.Infinity;


    /**
     * @return {Boolean}
     * @private
     */
    var _isScrolledBottom = function () {
        var currentScroll = document.documentElement.scrollTop || document.body.scrollTop;
        var totalHeight = document.body.offsetHeight;
        var clientHeight = document.documentElement.clientHeight;
        return totalHeight <= currentScroll + clientHeight;
    };



    return {
        /**
         * Init socket.io communication and log container
         *
         * @param {Object} opts options
         */
        init: function (opts) {
            var self = this;

            // Elements
            _logContainer = opts.container;
            _filterInput = opts.filterInput;
            _filterInput.focus();
            _topbar = opts.topbar;
            _body = opts.body;


            // socket.io init
            _socket = opts.socket;
            _socket
                .on('line', function (line) {
                    self.log(line);
                });
        },

        /**
         * Log data
         *
         * @param {string} data data to log
         */
        log: function (data) {
            var wasScrolledBottom = _isScrolledBottom();
            var div = document.createElement('div');
            var p = document.createElement('p');
            p.className = 'inner-line';

            // convert ansi color codes to html && escape HTML tags
            p.innerHTML = data;

            div.className = 'line';

            div.appendChild(p);
            _logContainer.innerHTML += data;

            if (_logContainer.children.length > _linesLimit) {
                _logContainer.removeChild(_logContainer.children[0]);
            }

            if (wasScrolledBottom) {
                window.scrollTo(0, document.body.scrollHeight);
            }

        }
    };
})(window, document);
