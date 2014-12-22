json.array!(@competencies) do |competency|
  json.extract! competency, :id, :description, :name, :numeric_weight, :verbal_weight
  json.url competency_url(competency, format: :json)
end
