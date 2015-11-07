Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/data', as: 'rails_admin'
  mount Spree::Core::Engine, :at => '/'
  Spree::Core::Engine.routes.draw do
    post 'products/get_ajax_best_day'
    post 'products/get_ajax_spree_travel'
    post 'products/get_ajax_price_travel'
    post 'products/get_ajax_aeromexico'
    get 'nomads/new'
    post 'nomads/create'

    resources :hotels, only: [:index, :show] do
      collection do
        get :detail
        get :booking
        get :thanks_you
      end
    end
    resources :cruises, only: [:index, :show] do
      collection do
        get :detail
        get :booking
        get :thanks_you
      end
    end
    resources :properties, only: [:index, :show] do
      collection do
        get :detail
        get :booking
        get :thanks_you
      end
    end
    resources :cars, only: [:index, :show] do
      collection do
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
        get :detail
        get :booking
        get :thanks_you
      end
    end
    resources :aboutus, only: [:index, :show] do
      collection do
        get :index
      end
    end
    resources :payment_policies, only: [:index, :show] do
      collection do
        get :index
      end
    end
    resources :terms_and_conditions, only: [:index, :show] do
      collection do
        get :index
      end
    end
    resources :privacy_policies, only: [:index, :show] do
      collection do
        get :index
      end
    end
    resources :contact_us, only: [:index, :show] do
      collection do
        get :index
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

    resources :home, only: :index do
      collection do
        get :index2
      end
    end

    namespace :admin do
      resources :static_images
      resources :static_events
      resources :static_deals
      resources :api_destinations
      resources :nomads
      resources :destinations do
        resources :attractions
      end

      resources :reports, only: [:index] do
        collection do
          get :sources_statistics
          post :sources_statistics

          get :custom_log
          post :custom_log

          get :custom_log_download
          post :custom_log_download
        end
      end
    end

  end
end
