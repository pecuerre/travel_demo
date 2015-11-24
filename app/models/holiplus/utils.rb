module Holiplus
  module Utils
    class << self

      def parse_house(item, availabilityItem = {})
        puts item.inspect
        puts '-----------------------'
        {
            :api => :holiplu,
            :id => item['id'],
            :name => item['name'],
            :title => item['name'],
            :description => '-',
            :destination => item['destination'],
            :availability => availabilityItem['availability'],
            :logo => nil,
            :image => item['image_cover'] ? item['image_cover']['path'] : nil,
            :images => (item['images'] || []).map { |i| i['path'] },
            :amenities => (item['services'] || []).map { |s| {:id => nil, :name => s} },
            :rating => 0,
            :properties => {
                :house_type => item['house_type'],
                :rooms => item['number_of_rooms'].to_i,
                :owner => item['owner'],
            }
        }
      end

      def parse_houses(items)
        items.map do |item|
          response = Holiplus::Api.houses({id: item['id']})
          parse_house(JSON.parse(response.body), item)
        end
      end

      def prepare_for_houses(params)
        {
            'apikey' => Figaro.env.HOLIPLUS_API_KEY,
            'destination' => params['search-going-to'].to_i,
            'checking' => Date.strptime(params['search-check-in-date'], '%m/%d/%Y').to_s,
            'checkout' => Date.strptime(params['search-check-out-date'], '%m/%d/%Y').to_s,
            'rooms[]' => "#{params['search-adults'].to_i}.#{(params['search-kids'].to_i)}.#{(params["search-infants"].to_i)}",
        }
      end

      def prepare_for_house(params)
        {
            'apikey' => Figaro.env.HOLIPLUS_API_KEY,
        }
      end

    end
  end
end

