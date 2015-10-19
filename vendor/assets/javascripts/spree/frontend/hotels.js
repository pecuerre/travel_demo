/**
 * Created by adrian on 10/15/14.
 */
$(window).load(function () {
    enquire.register("only screen and (min-width: 1310px)", {
        match: function () {
            $('#search-results').addClass('pull-left');
        },
        unmatch: function () {
            $('#search-results').removeClass('pull-left');
        }
    });
});