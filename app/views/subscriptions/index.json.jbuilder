json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :id, :email, :frequency, :rain, :high, :low, :location_id
  json.url subscription_url(subscription, format: :json)
end
