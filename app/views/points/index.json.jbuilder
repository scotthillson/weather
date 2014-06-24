json.array!(@points) do |point|
  json.extract! point, :id, :time, :high, :low, :rain, :cloud, :run_id
  json.url point_url(point, format: :json)
end
