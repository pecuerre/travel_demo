module ResourcesHelper
  def list_item_booking_uri(booking_uri, api_name, price)
    html = ''
    if booking_uri.is_a?(String)
      html << "<a href='#{booking_uri}' target=\"_blank\"><span class=\"site-name\">#{api_name.to_s.titleize}</span><span class=\"offer-price\">$ #{price}</span></a>"
    elsif booking_uri.is_a?(Hash) and booking_uri[:method] == :post
      html << form_tag(booking_uri[:url], authenticity_token: false, method: booking_uri[:method], target: "_blank")
        booking_uri[:params].each do |k, v|
          html << hidden_field_tag(k, v)
        end
        html << "<a href=\"#\" onclick=\"$(this).parent(\"form\").submit(); return false;\"><span class=\"site-name\">#{api_name.to_s.titleize}</span><span class=\"offer-price\">$ #{price}</span></a>"
      html << '</form>'
    end
    html
  end

  def item_booking_uri(booking_uri)
    html = ''
    if booking_uri.is_a?(String)
      html << "<a href=\"#{booking_uri}\" class='offer-book-btn pull-right' target='_blank'>#{I18n.t(:book_now)}<i class='icon icon-green-folder hidden-xs'></i></a>"
    elsif booking_uri.is_a?(Hash) and booking_uri[:method] == :post
      html << form_tag(booking_uri[:url], authenticity_token: false, method: booking_uri[:method], target: "_blank")
      booking_uri[:params].each do |k, v|
        html << hidden_field_tag(k, v)
      end
      html << "<a href='#' onclick=\"$(this).parent('form').submit(); return false;\" class='offer-book-btn pull-right'>#{I18n.t(:book_now)}<i class='icon icon-green-folder hidden-xs'></i></a>"
      html << '</form>'
    end
    html
  end
end
