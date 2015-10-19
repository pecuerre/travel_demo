//tabling at home
$(document).ready(function(){
    $('#main-navigation a').click(function(){
        var section =  $('section[data-hook="search-form-container"]:visible');
        $(section).children().hide();
        var search_type = $(this).attr('id');
        $("input[name='search-type'][value="+search_type+"]").parents('form').show();
        $(this).parents('ul').children().removeClass('current');
        $(this).parent('li').addClass('current');
        $('input#search-type').val(search_type)
    })
});

//$(function(){
//    $('input[name$="-date"]').datepicker({
//        pickTime: false,
//        minDate: '0',
//        numberOfMonths: 2
//    });
//    $('input[name$="-time"]').datetimepicker({
//        pickDate: false
//    });
//});

$(function(){
    $('input.form-control').click(function(){$(this).select();})
});

//click on calendar and clock icons
$(function(){
    $('i.icon-calendar,i.icon-clock').click(function(){
        $(this).parent().prev().focus();
    });
});

////toggle dropdowns by .input-group-addon click
$(document).ready(function(){
    $('.dropdown .input-group-addon').click(function(event){
        $(this).parent().prev().focus();
    });
});

$(window).load(function () {
    var $quickDestDrop = $('#quick-destiny-dropdown');
    var $searchFormContainer = $('#search-form-container-mobile');
    var $formLabels = $searchFormContainer.find('label');
    var $formInputs = $searchFormContainer.find('input[data-placeholder]');
    enquire.register("only screen and (max-width: 991px)", {
        match: function () {
            $quickDestDrop.addClass('pull-right');
        },
        unmatch: function () {
            $quickDestDrop.removeClass('pull-right');
        }
    });
    enquire.register("only screen and (max-width: 767px)", {
        match: function () {
            $formLabels.addClass('hidden');
            $formInputs.each(function(){
                $(this).attr('placeholder', $(this).data('placeholder'));
            });
        },
        unmatch: function () {
            $formLabels.removeClass('hidden');
            $formInputs.removeAttr('placeholder');
        }
    });
});

$(function(){
    $('#load-more-deals').click(function(event){
        event.preventDefault();
        alert('This click should load more deals or goes to another view... Do what you need to do');
    });
    $('#load-more-destinies').click(function(event){
        event.preventDefault();
        alert('This click should load more destinies or goes to another view... Do what you need to do');
    });
});

//$(window).ready(function(){
//    $("input.destination").autocomplete({source: '/destinations/search'});
//    $("input.airport").autocomplete({source: '/airports/search'})
//});

// Make flash messages disappear
setTimeout('$(".flash").fadeOut()', 15000);