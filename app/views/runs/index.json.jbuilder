json.array!(@runs) do |run|
  json.extract! run, :id, :run, :location, :model
  json.url run_url(run, format: :json)
end