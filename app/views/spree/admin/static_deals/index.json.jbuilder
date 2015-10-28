json.array!(@static_deals) do |static_deal|
  json.extract! static_deal, :id, :name, :description, :price, :link, :stars
  json.url static_deal_url(static_deal, format: :json)
end
