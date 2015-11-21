/*
 * Title:   Travelo | Responsive HTML5 Travel Template - Custom Javascript file
 * Author:  Yoandry Pacheco Aguila <yoandrypa@gamil.com>
 */

tjq(document).ready(function () {

    var mustacheHelpers = {
        /**
         * Returns rating in %.
         *
         * @returns {number}
         */
        _stars_: function () {
            return this.rating / 5 * 100;
        }
    }

    // Show and hidden loading dialog in each ajax request.
    tjq('body').ajaxStart(function () {
        tjq(this).Loading().start();
    }).ajaxComplete(function () {
        tjq(this).Loading().stop();
    });

    /**
     * Method to serialize form data into object.
     * Applicable to forms element.
     *
     * @returns {Object}
     */
    tjq.fn.serializeObject = function () {
        var obj = {};
        this.serializeArray().forEach(function (i) {
            obj[i.name] = i.value
        });
        return obj;
    }

    /**
     * Method to search products and saving into local store.
     * Applicable to search forms element.
     *
     * @param type {String} Type of product (hotels, cars, flights, ...)
     * @param service {String} Remote service url. Ej: '/api/hotels'
     */
    tjq.fn.searchProducts = function (type, service, done) {
        var data = tjq(this).serializeObject();

        tjq.ajax({
            url: service,
            type: 'POST',
            data: data,
            success: function (response) {
                // Save data in local storage.
                localStorage.setItem(type, JSON.stringify({items: response}));
                done(true);
            },
            error: function (response) {
                done(false, response.responseJSON);
            }
        });
    }

    /**
     * Method to render products saved in local store.
     *
     * @param type {String} Type of product (hotels, cars, flights, ...)
     */
    tjq.fn.renderProducts = function (type) {
        var data = JSON.parse(localStorage.getItem(type) || '{"items":[]}'),
            templateId = type + '-' + localStorage.getItem('product-view-type') || 'list';

        for (var i in mustacheHelpers) {
            data[i] = mustacheHelpers[i];
        }

        tjq('.search-results-title b').html(data.items.length);

        // Render response items.
        tjq(this).html('');
        tjq(this).mustache(templateId, data);
    }

    // Method to add option to select element from remote service response.
    tjq.fn.loadSelectOptions = function (service, type, data) {
        var element = this;
        tjq.ajax({
            url: service,
            type: type || 'GET',
            data: data || {},
            contentType: 'application/json; charset=utf-8',
            success: function (response) {
                response.forEach(function (item) {
                    element.append($('<option>', {value: item.id}).text(item.name));
                });
            }
        });
    }

});
