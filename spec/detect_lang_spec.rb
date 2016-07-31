require_relative 'spec_helper'

{
    'en,de' => ['Hello World!', 'en'],
    'ru,ua' => [URI::encode('Всем Привет!'), 'ru'],

}
    .each do |hint, (text, detected_lang_code)|
  describe('Yandex Translator Api') do
    it('/detect and method "Get" should return a 200 and detect language of the sample text') do
      request = YandexTranslatorSteps::Api.new do |options|
        options.method = 'Get'
        options.base_uri = BASE_URI
        options.endpoint = '/detect'
        options.query = {'key' => API_KEY, 'text' => text, 'hint' => hint}
      end
      response = request.execute
      expect(response.code.to_i).to eq(200)
      expected_response = {'code' => 200, 'lang' => detected_lang_code}
      expect(JSON[response.body]).to eq(expected_response),
                                     "Expected that response body to be equal: #{expected_response}
                                       but got: #{JSON[response.body]}."
    end
  end
end