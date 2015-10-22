json.array!(@nomads) do |nomad|
  json.extract! nomad, :id, :first_name, :last_name, :age, :email, :contry, :destination, :reason, :expect, :skills
  json.url nomad_url(nomad, format: :json)
end
