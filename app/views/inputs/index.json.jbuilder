json.array!(@inputs) do |input|
  json.extract! input, :id, :file
  json.url input_url(input, format: :json)
end
