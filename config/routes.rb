Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/data', as: 'rails_admin'
  mount Spree::Core::Engine, :at => '/'
  Spree::Core::Engine.routes.draw do
  mount RailsAdmin::Engine => '/data', as: 'rails_admin'
    resources :hotels, only: [:index, :show] do
      collection do
        get :list
        get :grid
        get :block
        get :detail
        get :booking
        get :thanks_you
      end
    end
    resources :properties, only: [:index, :show] do
      collection do
        get :list
        get :grid
        get :block
        get :detail
        get :booking
        get :thanks_you
      end
    end
    resources :cars, only: [:index, :show] do
      collection do
        get :list
        get :grid
        get :block
        get :detail
        get :booking
        get :thanks_you
      end
    end
    resources :tours do
      collection do
        get :index
        get :booking
        get :detail1
        get :detail2
        get :fancy_package_2column
        get :fancy_package_3column
        get :fancy_package_4column
        get :location_europe
        get :location_north_america
        get :simple_package_2column
        get :simple_package_3column
        get :simple_package_4column
      end
    end
    resources :flights, only: [:index, :show] do
      collection do
        get :list
        get :grid
        get :block
        get :detail
        get :booking
        get :thanks_you
      end
    end
    resources :destinations, only: [:index, :show] do
      collection do
        get :list
        get :grid
        get :block
        get :detail
        get :booking
        get :thanks_you
      end
    end
    
    resources :pages do
      collection do
        get :error_404_1
        get :error_404_2
        get :error_404_3
        get :aboutus1
        get :aboutus2
        get :blog_fullwidth
        get :blog_leftsidebar
        get :blog_read
        get :blog_rightsidebar
        get :coming_soon1
        get :coming_soon2
        get :coming_soon3
        get :contactus1
        get :contactus2
        get :contactus3
        get :faq1
        get :faq2
        get :layouts_fullwidth
        get :layouts_leftsidebar
        get :layouts_rightsidebar
        get :layouts_twosidebar
        get :loading1
        get :loading2
        get :loading3
        get :login1
        get :login2
        get :login3
        get :photogallery_2column
        get :photogallery_3column
        get :photogallery_4column
        get :photogallery_fullview
        get :services1
        get :services2
        get :services3
        get :travelo_policies
        get :sitemap
      end
    end
    
    resources :extra_pages do
      collection do
        get :before_you_fly
        get :group_booking
        get :holidays
        get :hotdeals
        get :inflight_experience
        get :things_todo1
        get :things_todo2
        get :travel_essentials
        get :travel_guide
        get :travel_ideas
        get :travel_insurance
        get :travel_stories
      end
    end
    
    resources :shortcodes do
      collection do
        get :accordions_toggles
        get :animations
        get :buttons
        get :dropdowns
        get :gallery_popup
        get :gallery_styles
        get :icon_boxes
        get :image_box_styles
        get :listing_style1
        get :listing_style2
        get :listing_style3
        get :map_popup
        get :our_team
        get :pricing_tables
        get :style_changer
        get :tabs
        get :testimonials
        get :typography
        get :homepage2
        get :homepage3
        get :homepage4
        get :homepage5
        get :homepage6
        get :homepage7
        get :homepage8
        get :homepage9
        get :homepage10
        get :homepage11
      end
    end
    
    resources :home, only: :index
    
  end
end
