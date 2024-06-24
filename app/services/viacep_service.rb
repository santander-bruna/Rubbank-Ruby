require 'rest-client'

class ViaCepService
  BASE_URL = 'https://viacep.com.br/ws'.freeze

  def search_cep(cep)
    response = RestClient.get("#{BASE_URL}/#{cep}/json")
    JSON.parse(response.body)
  end
end