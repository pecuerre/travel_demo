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
    
    API_KEY = "AIzaSyA15zfbyhsBSWwjBwTCQKvXIpvr1Cdi1-Y"

    def google_map_photos(latitude,longitude)

      latitude ||= 23.1165 
      longitude ||= -82.3882

      url_photos = []
      @client ||= GooglePlaces::Client.new(API_KEY) 
      spots = @client.spots(latitude, longitude) #, :types => google_types, :exclude => google_types

      spots.each do |spot|
        break if url_photos.length >= 10             
        url_photos << spot.photos[0].fetch_url(800)  unless spot.photos.blank?
      end
      return  url_photos   
    end
 
    def google_types
      types = %W( airport amusement_park aquarium art_gallery bakery bar bicycle_store cafe campground car_rental
                  casino food museum night_club park restaurant roofing_contractor shopping_mall spa stadium       
                  travel_agency zoo )
      return types
     end

    def google_exclude
      exclude = %W( accounting airport atm bakery bank book_store bowling_alley bus_station car_dealer
                    car_repair car_wash cemetery city_hall clothing_store convenience_store
        courthouse
        dentist
        department_store
        doctor
        electrician
        electronics_store
        embassy
        establishment
        finance
        fire_station
        florist
        funeral_home
        furniture_store
        gas_station
        general_contractor
        hair_care
        hardware_store
        health
        hindu_temple
        home_goods_store
        hospital
        insurance_agency
        jewelry_store
        laundry
        lawyer
        liquor_store
        local_government_office
        locksmith
        lodging
        meal_delivery
        meal_takeaway
        mosque
        movie_rental
        movie_theater
        moving_company
        painter
        parking
        pet_store
        pharmacy
        physiotherapist
        place_of_worship
        plumber
        police
        post_office
        real_estate_agency
        roofing_contractor
        rv_park
        school
        shoe_store
        storage
        subway_station
        synagogue
        taxi_stand
        train_station
        university
        veterinary_care
      )
     end
    

    def product_map(product)
      #TODO: (peter si quieres has una rama develop o local, pero en el master del github no debe estar variat=0)
      variant = 1
      full_url = ''
      # TODO: los valores por defecto sacarlos de Spree::Config::Location.default_latitude
   
      product.location ||= Spree::Location.new(:latitude => 23.1341642187384, :longitude => -82.3605751991272)

      latitude = product.location.latitude
      longitude = product.location.longitude

      case variant
      when 0
        full_url = '/assets/habana.jpg'
      when 1
        url = "http://maps.google.com/maps/api/staticmap"
        options = {}
        options[:size] = '338x244'
        options[:maptype] = 'roadmap'
        options[:sensor] = 'false'
        options[:markers] = "#{latitude},#{longitude},red"
        options[:center] = "#{latitude},#{longitude}"
        options[:zoom] = 9
        query_string = options.keys.collect{|key| "#{key}=#{options[key]}"}.join('&')
        full_url = "#{url}?#{query_string}"
      when 2
        # TODO: resolve issue?? (migue que problema hay aqui??)
        map = GoogleStaticMapsHelper::Map.new :size => '338x244', :sensor => true, :zoom => 7
        marker = GoogleStaticMapsHelper::Marker.new( :lng => longitude, :lat => latitude, :color => 'red', :size => 'normal')
        map << marker
        full_url = map.url
      end
      %<<img src="#{full_url}" width="338" height="244">>.html_safe
    end

end
