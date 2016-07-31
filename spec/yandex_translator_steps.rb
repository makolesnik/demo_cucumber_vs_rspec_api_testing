module YandexTranslatorSteps
  class Api
    attr_accessor :method, :base_uri, :endpoint, :query, :payload, :content_type

    def initialize
      yield self if block_given?
    end

    def execute
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
  end
end
