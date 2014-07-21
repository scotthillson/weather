json.array!(@logs) do |log|
  json.extract! log, :id, :action, :note, :run
  json.url log_url(log, format: :json)
end
