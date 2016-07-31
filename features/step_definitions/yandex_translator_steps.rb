Given(/^a "REST" API definition at "(.+)"$/) do |base_uri|
  @base_uri = eval(base_uri)
end

And(/^security query param "([^"]*)" equals "([^"]*)"$/) do |query_param, query_param_value|
  @query ||= {}
  @query.merge!(query_param => eval(query_param_value))
end

Given(/^endpoint "(.+)" and method "(.+)"$/) do |endpoint, method|
  @endpoint = endpoint
  @method = method.capitalize
end

And(/^content type "([^"]*)"$/) do |content_type|
  @content_type = content_type
end

And(/^request query param "([^"]*)" equals "([^"]*)"$/) do |query_param, query_param_value|
  @query ||= {}
  @query.merge!(query_param => query_param_value)
end

And(/^request payload param "([^"]*)" equals "([^"]*)"$/) do |query_param, query_param_value|
  @payload ||= {}
  @payload.merge!(query_param => query_param_value)
end

And(/^request query params$/) do |table|
  table = Hash[table.hashes.map(&:values)]
  table.each { |k, v| (table[k] = v.to_i) if v && v.to_s.match(/^\d+$/) }
  table.each { |k, v| (table[k] = eval(v)) if v && v.to_s.match(/^\[.+\]$/) }
  table.each { |k, v| (table[k] = eval(v.to_s.tr(':', '=>'))) if v && v.to_s.match(/^\{.+\}$/) }
  @query ||= {}
  @query.merge!(table)
end

And(/^request payload params$/) do |table|
  table = Hash[table.hashes.map(&:values)]
  table.each { |k, v| (table[k] = v.to_i) if v && v.to_s.match(/^\d+$/) }
  table.each { |k, v| (table[k] = eval(v)) if v && v.to_s.match(/^\[.+\]$/) }
  table.each { |k, v| (table[k] = eval(v.to_s.tr(':', '=>'))) if v && v.to_s.match(/^\{.+\}$/) }
  @payload ||= {}
  @payload.merge!(table)
end

When(/^the request is executed$/) do
  @query.each { |k, v| (@query[k] = URI::encode(v.to_s)) }
  @params = @query.each.with_object([]) { |(k, v), o| o << "#{k}=#{v}" }.join('&')
  uri = URI.parse(@base_uri + @endpoint + '?' + @params)
  request = Net::HTTP.const_get(@method).new(uri)
  if @content_type == 'form'
    request.content_type = 'application/x-www-form-urlencoded'
  elsif @content_type == 'json'
    request.content_type = 'application/json'
  end
  if @payload
    if @content_type == 'form'
      request.set_form_data(@payload)
    else
      request.body = @payload.to_json
    end
  end

  @response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(request)
  end
end

Then(/^response status is "([^"]*)"$/) do |code|
  code = code
  expect(@response.code).to eq(code),
                            "Expected response status #{code} but got #{@response.code}.
                             Request infomation:
                             Method: #{@method}
                             Endpoint: #{(@base_uri + @endpoint)}
                             Payload or Query Params: #{@params}"
end

And(/^response body has attributes$/) do |table|
  table = Hash[table.hashes.map(&:values)]
  table.each { |k, v| (table[k] = v.to_i) if v && v.to_s.match(/^\d+$/) }
  table.each { |k, v| (table[k] = eval(v)) if v && v.to_s.match(/^\[.+\]$/) }
  table.each { |k, v| (table[k] = eval(v.to_s.split(':').join('=>'))) if v && v.to_s.match(/^\{.+\}$/) }

  if table.values.any?
    actual_params = JSON[@response.body].to_a
    expected_params = table.to_a
    expect(expected_params.all? { |p| actual_params.include?(p) }).to be_truthy,
                                                                      "Expected that response body has attributes: #{expected_params}
                                                                       but got: #{actual_params}."
  else
    expect(JSON[@response.body].keys.sort).to eq(table.keys.sort),
                                              "Expected that response body has attributes: #{table.keys}
                                               but got: #{JSON[@response.body].keys}."
  end
end
