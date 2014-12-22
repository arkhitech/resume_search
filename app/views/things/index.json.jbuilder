json.array!(@things) do |thing|
  json.extract! thing, :id, :name, :description, :person_id
  json.url thing_url(thing, format: :json)
end
