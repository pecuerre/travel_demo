Spree::BaseHelper.class_eval do

    def flash_messages(opts = {})
      ignore_types = ["order_completed"].concat(Array(opts[:ignore_types]).map(&:to_s) || [])

      flash.each do |msg_type, text|
        unless ignore_types.include?(msg_type)
          if msg_type == 'success'
            concat(raw("<script type='text/javascript'>alert('#{t('delivery_success')}'); </script>"))
          elsif msg_type == 'error'
            concat(raw("<script type='text/javascript'>alert('#{t('delivery_error')}'); </script>"))
          end
        end
      end
      nil
    end
end
