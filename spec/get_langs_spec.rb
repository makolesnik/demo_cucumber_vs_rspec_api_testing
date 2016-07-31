require_relative 'spec_helper'

{
    'en' => ['dirs', 'langs'],
    'ru' => ['dirs', 'langs'],
    'ua' => ['dirs'],
    'sp' => ['dirs'],
    'de' => ['dirs', 'langs'],
    'fr' => ['dirs']
}
    .each do |lang_code, response_body_attributes|
  describe('Yandex Translator Api ') do
    it('/getLangs and method "Get" should return a 200 and list of languages') do
      request = YandexTranslatorSteps::Api.new do |options|
        options.method = 'Get'
        options.base_uri = BASE_URI
        options.endpoint = '/getLangs'
        options.query = {'key' => API_KEY, 'ui' => lang_code}
      end
      response = request.execute
      expect(response.code.to_i).to be(200)
      expect(JSON[response.body].keys.sort).to eq(response_body_attributes.sort),
                                               "Expected that response body has attributes: #{response_body_attributes}
                                                but got: #{JSON[response.body].keys} for #{lang_code}."
    end
  end
end
