require_relative 'spec_helper'

describe('Yandex Translator Api ') do
  it('/translate and method "Get" should return a 200 and translation of the text') do
    request = YandexTranslatorSteps::Api.new do |options|
      options.method = 'Get'
      options.base_uri = BASE_URI
      options.endpoint = '/translate'
      options.query = {
          'key' => API_KEY,
          'text' => 'Hello World!',
          'lang' => 'ru',
          'format' => 'plain',
          'options' => 1
      }
    end
    response = request.execute
    expect(response.code.to_i).to eq(200)
    expected_response = {
        'code' => 200,
        'lang' => 'en-ru',
        'text' => ['Всем Привет!'],
        'detected' => {'lang' => 'en'}
    }
    expect(JSON[response.body]).to eq(expected_response),
                                   "Expected that response body to be equal: #{expected_response}
                                   but got: #{JSON[response.body]}."
  end

  it('/translate and method "Post" should return a 200 and translation of the text') do
    request = YandexTranslatorSteps::Api.new do |options|
      options.method = 'Post'
      options.base_uri = BASE_URI
      options.endpoint = '/translate'
      options.query = {
          'key' => API_KEY,
          'text' => 'Hello World!',
          'lang' => 'ru',
          'format' => 'plain',
          'options' => 1
      }
      options.payload = {'text' => 'Hello World!'}
      options.content_type = 'form'
    end
    response = request.execute
    expect(response.code.to_i).to eq(200)
    expected_response = {
        'code' => 200,
        'lang' => 'en-ru',
        'text' => ['Всем Привет!'],
        'detected' => {'lang' => 'en'}
    }
    expect(JSON[response.body]).to eq(expected_response),
                                   "Expected that response body to be equal: #{expected_response}
                                   but got: #{JSON[response.body]}."
  end
end
