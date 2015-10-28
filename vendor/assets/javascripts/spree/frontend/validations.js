function add_flash(message){
    $('#content').children().first().before('<div class="flash alert">'+message+'</div>');
    setTimeout('$(".flash").fadeOut()', 5000);
}

$(function(){
    $('input#filter-submit').click(function(){
        var min_price = $('form#filters input#filter-min-price');
        if (min_price.val() && min_price.val() != '' && (!Number.parseInt(min_price.val()) || Number.parseInt(min_price.val()) <= 0)){
            add_flash($('div#messages input#min_price_invalid').val());
            return false
        }
        var max_price = $('form#filters input#filter-max-price');
        if (max_price.val() && max_price.val() != '' && (!Number.parseInt(max_price.val()) || Number.parseInt(max_price.val()) <= 0)){
            add_flash($('div#messages input#max_price_invalid').val());
            return false
        }
        if (min_price.val() && max_price.val() && min_price.val() != '' && max_price.val() != '' && Number.parseInt(max_price.val()) <= Number.parseInt(min_price.val())){
            add_flash($('div#messages input#invalid_prices_order').val());
            return false
        }
    })
})

$(function(){
    $('input#search-submit').click(function(){
        var form = $(this).parents('form');
        var search_type = form.children('input:hidden[name="search-type"]').val();
        switch (search_type){
            case 'flights':
                var flight_type = $('form:visible[data-hook="flights"] button[name="search-flight-type"]');
                if (flight_type.val()==''){
                    add_flash($('div#messages input#flight_type_blank').val());
                    return false
                }
                if (!(flight_type.val()=='roundtrip' || flight_type.val()== 'one way' || flight_type.val()== 'redondo' || flight_type.val()== 'sencillo')){
                    add_flash($('div#messages input#flight_type_invalid').val());
                    return false
                }
                var flying_from = $('form:visible[data-hook="flights"] input[name="search-flying-from"]');
                if (flying_from.val()==''){
                    add_flash($('div#messages input#flying_from_blank').val());
                    return false
                }
                var flying_to = $('form:visible[data-hook="flights"] input[name="search-flying-to"]');
                if (flying_to.val()==''){
                    add_flash($('div#messages input#flying_to_blank').val());
                    return false
                }
                var departing_date = $('form:visible[data-hook="flights"] input[name="search-departing-date"]');
                if (!Date.parse(departing_date.val())){
                    add_flash($('div#messages input#departing_date_invalid').val());
                    return false
                }
                var returning_date = $('form:visible[data-hook="flights"] input[name="search-returning-date"]');
                if ((flight_type.val() == 'roundtrip' || flight_type.val() == 'redondo') && !Date.parse(returning_date.val())){
                    add_flash($('div#messages input#returning_date_invalid').val());
                    return false;
                }
                else{
                    if(Date.parse(returning_date.val())<Date.parse(departing_date.val())){
                        add_flash($('div#messages input#invalid_chronological_order').val());
                        return false
                    }
                }
                var adults = $('form:visible[data-hook="flights"] button[name="search-adults"]');
                if (!Number.parseInt(adults.val()) || Number.parseInt(adults.val()) <= 0){
                    add_flash($('div#messages input#adults_invalid').val());
                    return false
                }
                var kids = $('form:visible[data-hook="flights"] button[name="search-kids"]');
                if (kids.val() && (!(Number.parseInt(kids.val())+1) || Number.parseInt(kids.val()) < 0)){
                    add_flash($('div#messages input#kids_invalid').val());
                    return false
                }
                break;
            case 'hotels':
                var going_to = $('form:visible[data-hook="hotels"] input[name="search-going-to"]');
                if (going_to.val()==''){
                    add_flash($('div#messages input#going_to_blank').val());
                    return false
                }
                var check_in = $('form:visible[data-hook="hotels"] input[name="search-check-in-date"]');
                if (!Date.parse(check_in.val())){
                    add_flash($('div#messages input#check_in_invalid').val());
                    return false
                }
                var check_out = $('form:visible[data-hook="hotels"] input[name="search-check-out-date"]');
                if (!Date.parse(check_out.val())){
                    add_flash($('div#messages input#check_out_invalid').val());
                    return false
                }
                if(Date.parse(check_out.val())<Date.parse(check_in.val())){
                    add_flash($('div#messages input#invalid_chronological_order').val());
                    return false
                }
                var rooms = $('form:visible[data-hook="hotels"] button[name="search-rooms"]');
                if (!Number.parseInt(rooms.val()) || Number.parseInt(rooms.val()) <= 0){
                    add_flash($('div#messages input#rooms_invalid').val());
                    return false
                }
                var adults = $('form:visible[data-hook="hotels"] button[name="search-adults"]');
                if (!Number.parseInt(adults.val()) || Number.parseInt(adults.val()) <= 0){
                    add_flash($('div#messages input#adults_invalid').val());
                    return false
                }
                var kids = $('form:visible[data-hook="hotels"] button[name="search-kids"]');
                if (kids.val() && (!(Number.parseInt(kids.val())+1) || Number.parseInt(kids.val()) < 0)){
                    add_flash($('div#messages input#kids_invalid').val());
                    return false
                }
                break;
            case 'cars':
                var picking_up = $('form:visible[data-hook="cars"] input[name="search-picking-up"]');
                if (picking_up.val()==''){
                    add_flash($('div#messages input#picking_up_blank').val());
                    return false
                }
                var dropping_off = $('form:visible[data-hook="cars"] input[name="search-dropping-off"]');
                if (dropping_off.val()==''){
                    add_flash($('div#messages input#dropping_off_blank').val());
                    return false
                }
                var pick_up_date = $('form:visible[data-hook="cars"] input[name="search-pick-up-date"]');
                if (!Date.parse(pick_up_date.val())){
                    add_flash($('div#messages input#pick_up_date_invalid').val());
                    return false
                }
                var pick_up_time = $('form:visible[data-hook="cars"] input[name="search-pick-up-time"]');
                if (pick_up_time.val() == '' || !Date.parse(pick_up_date.val() + ' ' + pick_up_time.val())){
                    add_flash($('div#messages input#pick_up_time_invalid').val());
                    return false
                }
                var drop_off_date = $('form:visible[data-hook="cars"] input[name="search-drop-off-date"]');
                if (!Date.parse(drop_off_date.val())){
                    add_flash($('div#messages input#drop_off_date_invalid').val());
                    return false
                }
                var drop_off_time = $('form:visible[data-hook="cars"] input[name="search-drop-off-time"]');
                if (drop_off_time.val() == '' || !Date.parse(drop_off_date.val() + ' ' + drop_off_time.val())){
                    add_flash($('div#messages input#drop_off_time_invalid').val());
                    return false
                }
                if (Date.parse(drop_off_date.val() + ' ' + drop_off_time.val()) < Date.parse(pick_up_date.val() + ' ' + pick_up_time.val())){
                    add_flash($('div#messages input#invalid_chronological_order').val());
                    return false
                }
                break;
            case 'packages':
                var going_to = $('form:visible[data-hook="packages"] input[name="search-going-to"]');
                if (going_to.val()==''){
                    add_flash($('div#messages input#going_to_blank').val());
                    return false
                }
                var flying_from = $('form:visible[data-hook="packages"] input[name="search-flying-from"]');
                if (flying_from.val()==''){
                    add_flash($('div#messages input#flying_from_blank').val());
                    return false
                }
                var arrival_date = $('form:visible[data-hook="packages"] input[name="search-arrival-date"]');
                if (!Date.parse(arrival_date.val())){
                    add_flash($('div#messages input#arrival_date_invalid').val());
                    return false
                }
                var departure_date = $('form:visible[data-hook="packages"] input[name="search-departure-date"]');
                if (!Date.parse(departure_date.val())){
                    add_flash($('div#messages input#departure_date_invalid').val());
                    return false
                }
                if (Date.parse(departure_date.val()) < Date.parse(arrival_date.val())){
                    add_flash($('div#messages input#invalid_chronological_order').val());
                    return false
                }
                var rooms = $('form:visible[data-hook="packages"] button[name="search-rooms"]');
                if (!Number.parseInt(rooms.val()) || Number.parseInt(rooms.val()) <= 0){
                    add_flash($('div#messages input#rooms_invalid').val());
                    return false
                }
                var adults = $('form:visible[data-hook="packages"] button[name="search-adults"]');
                if (!Number.parseInt(adults.val()) || Number.parseInt(adults.val()) <= 0){
                    add_flash($('div#messages input#adults_invalid').val());
                    return false
                }
                var kids = $('form:visible[data-hook="packages"] button[name="search-kids"]');
                if (kids.val() && (!(Number.parseInt(kids.val())+1) || Number.parseInt(kids.val()) < 0)){
                    add_flash($('div#messages input#kids_invalid').val());
                    return false
                }
                break
        }
    })
});