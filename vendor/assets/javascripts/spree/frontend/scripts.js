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
        var data = tjq(this).serializeObject(),
            date = tjq.datepicker.formatDate('yy-mm-dd', new Date()),
            params = tjq(this).serialize(),
            cache = JSON.parse(localStorage.getItem(type) || "false");

        // If not is in search-result-section go to it.
        if (tjq('#search-result-items').length == 0) {
            tjq('section#content div#main div.row').html('');
            tjq('section#content div#main div.row').mustache('search-result-section');
        }

        if (!cache || cache.date != date || cache.service != service || cache.params != params) {
            tjq.ajax({
                url: service,
                type: 'POST',
                data: data,

                success: function (response) {
                    // Save data in local storage.
                    localStorage.setItem(type, JSON.stringify({
                        items: response,
                        service: service,
                        params: params,
                        date: date
                    }));
                    done(true);
                },

                error: function (response) {
                    var errors = JSON.parse(response.responseText);

                    if (errors instanceof Array) {
                        errors = errors.map(function (i) {
                            return i.error
                        })
                    } else {
                        console.error(errors);
                        errors = ['The failed request.', 'Please try again later.'];
                    }

                    tjq.msgBox({
                        title: "Error",
                        content: errors.join('<br/>'),
                        type: "error",
                        showButtons: true,
                        opacity: 0.9
                    });

                    done(false, errors);
                }
            });
        } else {
            tjq(this).unserializeForm(cache.params);
            done(true);
        }
    }

    /**
     * Method to render products saved in local store.
     *
     * @param type {String} Type of product (hotels, cars, flights, ...)
     */
    tjq.fn.renderProducts = function (type) {
        var data = JSON.parse(localStorage.getItem(type) || '{"items":[]}'),
            viewType = localStorage.getItem('products-view-type') || 'list';

        for (var i in mustacheHelpers) {
            data[i] = mustacheHelpers[i];
        }

        // Show the amount of products found.
        tjq('.search-results-title b').html(data.items.length);

        // Reconnect event to change products items view when clicked in list, grid or block options.
        tjq('.products-view-type li a').off('click').on('click', function (e) {
            var data = tjq(this).data();

            localStorage.setItem('products-view-type', data.view);
            tjq('#search-result-items').renderProducts(type);

            e.preventDefault();
        });

        // Show response items.
        tjq(this).html('');
        tjq(this).mustache('products-view-as-' + viewType, data);

        // Reconnect event to show product details when clicked in 'TITLE' or 'SELECT' button.
        tjq('a.product-details').off('click').on('click', function (e) {
            var data = tjq(this).data();

            // TODO: Obtener data para la vista detalles.
            console.log(data);

            // Render response items.
            tjq('section#content div#main div.row').html('');
            tjq('section#content div#main div.row').mustache('product-details', data);

            e.preventDefault();
        });

        data.items.forEach(function (item) {

            // Create image gallery for each product.
            tjq('#product-gallery-' + item.id).magnificPopup({
                type: 'image',
                mainClass: 'mfp-img-mobile',
                //showCloseBtn: false,
                closeBtnInside: false,
                gallery: {
                    enabled: true,
                    navigateByImgClick: true,
                    preload: [0, 1] // Will preload 0 - before current, and 1 after the current image
                },
                items: item.images.map(function (img) {
                    return {src: img}
                })
            });
        });
    }

    /**
     * Method to add option to select element from remote service response.
     *
     * @param service {String} Remote service url. Ej: '/api/hotels'
     * @param data {Object} Parameters to send in request.
     * @param method {String} Http request method (GET, POST, PUT, DELETE, ...)
     */
    tjq.fn.loadSelectOptions = function (service, data, method) {
        var element = this;
        tjq.ajax({
            url: service,
            type: method || 'GET',
            data: data || {},
            async: false,
            contentType: 'application/json; charset=utf-8',
            success: function (response) {
                response.forEach(function (item) {
                    element.append($('<option>', {value: item.id}).text(item.name));
                });
            }
        });
    }

});
