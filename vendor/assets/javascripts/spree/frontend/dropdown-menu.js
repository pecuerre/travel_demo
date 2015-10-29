/**
 * Created by adrian on 9/28/14.
 */

$(document).ready(function(){
    $("ul.dropdown-menu a").click(function(){
        var input = $(this).parent().parent().prev().children();
        input.val($(this).html());
        input.change();
    })
});

$(document).ready(function(){
    $('input[name="search-flight-type"]').change(function(){
        var div = $('input#search-returning-date').parent().parent()
        if($(this).val() == 'Roundtrip' || $(this).val() == 'redondo'){
            div.show()
        }
        if($(this).val() == 'One way' || $(this).val() == 'sencillo'){
            div.hide()
        }
    })
})

$(document).ready(function(){
    $('input[name="search-flight-type"]').change()
})