Spree::Image.class_eval do
  has_attached_file :attachment,
                    styles: { mini: '58x39>', small: '206X137>', product: '270x160>', large: '900x500>' },
                    default_style: :product,
                    url: '/spree/products/:id/:style/:basename.:extension',
                    path: ':rails_root/public/spree/products/:id/:style/:basename.:extension',
                    convert_options: { all: '-strip -auto-orient -colorspace sRGB' }
end