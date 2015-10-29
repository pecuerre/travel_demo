//-------------------------------------------------
//		Quick Pager jquery plugin
//		Created by dan and emanuel @geckonm.com
//		www.geckonewmedia.com
//
//
//		18/09/09 * bug fix by John V - http://blog.geekyjohn.com/
//		1.2 - allows reloading of pager with new items
//-------------------------------------------------

(function($) {

    $.fn.quickPager = function(options) {

        var defaults = {
            pageSize: 10,
            currentPage: 1,
            holder: null,
            pagerLocation: "after"
        };

        var options = $.extend(defaults, options);


        return this.each(function() {


            var selector = $(this);
            var pageCounter = 1;

            if (selector.parents(".simplePagerContainer").length == '0' ){
                selector.wrap("<div class='simplePagerContainer'></div>");
            }

            selector.parents(".simplePagerContainer").find("ul.simplePagerNav").remove();

            selector.children().each(function(i){

                previousPage = $(this).data('page-counter');

                if (previousPage != undefined){
                    //If the plugin is re-initialized then remove old simplePagerPage
                    $(this).removeClass('simplePagerPage' + previousPage);
                }

                if(i < pageCounter*options.pageSize && i >= (pageCounter-1)*options.pageSize) {
                    $(this).addClass("simplePagerPage"+pageCounter);
                    $(this).attr('data-page-counter', pageCounter);
                }
                else {
                    $(this).addClass("simplePagerPage"+(pageCounter+1));
                    $(this).attr('data-page-counter', pageCounter + 1 );
                    pageCounter ++;
                }
            });

            options.minPage = 1;
            options.MaxPage = pageCounter;

            // show/hide the appropriate regions
            selector.children().hide();
            selector.children(".simplePagerPage"+options.currentPage).show();

            if(pageCounter <= 1) {
                return;
            }

            //Build pager navigation
            var pageNav = "<ul class='col-md-12 simplePagerNav'>";
            pageNav += "<li class='simplePageNav previous'><a rel='-' href='#'> &laquo; </a></li>";
            for (i=1;i<=pageCounter;i++){
                if (i==options.currentPage) {
                    pageNav += "<li class='currentPage simplePageNav"+i+"'><a rel='"+i+"' href='#'>"+i+"</a></li>";
                }
                else {
                    pageNav += "<li class='simplePageNav"+i+"'><a rel='"+i+"' href='#'>"+i+"</a></li>";
                }
            }
            pageNav += "<li class='simplePageNav next'><a rel='+' href='#'> &raquo; </a></li>";
            pageNav += "</ul>";

            if(!options.holder) {
                switch(options.pagerLocation)
                {
                    case "before":
                        selector.before(pageNav);
                        break;
                    case "both":
                        selector.before(pageNav);
                        selector.after(pageNav);
                        break;
                    default:
                        selector.after(pageNav);
                }
            }
            else {
                $(options.holder).append(pageNav);
            }

            //pager navigation behaviour
            selector.parent().find(".simplePagerNav a").click(function() {

                //grab the REL attribute
                var clickedLink = $(this).attr("rel");
                switch (clickedLink)
                {
                    case '+':
                        clickedLink = parseInt(options.currentPage, 10) + 1;
                        break;
                    case '-':
                        clickedLink = parseInt(options.currentPage, 10) - 1;
                        break;
                    default:
                        //Do nothing... keep the behaviour

                }
                if (options.minPage > clickedLink || options.MaxPage < clickedLink) {
                    //Invalid page... do not go beyond first or last page
                    return;
                };
                options.currentPage = clickedLink;

                if(options.holder) {
                    $(this).parent("li").parent("ul").parent(options.holder).find("li.currentPage").removeClass("currentPage");
                    $(this).parent("li").parent("ul").parent(options.holder).find("a[rel='"+clickedLink+"']").parent("li").addClass("currentPage");
                }
                else {
                    //remove current current (!) page
                    $(this).parent("li").parent("ul").parent(".simplePagerContainer").find("li.currentPage").removeClass("currentPage");
                    //Add current page highlighting
                    $(this).parent("li").parent("ul").parent(".simplePagerContainer").find("a[rel='"+clickedLink+"']").parent("li").addClass("currentPage");
                }

                //hide and show relevant links
                selector.children().hide();
                selector.find(".simplePagerPage"+clickedLink).show();

                return false;
            });
        });
    }


})(jQuery);

