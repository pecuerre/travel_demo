Spree::Order.class_eval do |clazz|

  remove_checkout_step :delivery

end