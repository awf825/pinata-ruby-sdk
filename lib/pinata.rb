require 'net/http'
require 'uri'

class Pinata
    def initialize(key, secret)
        @key = key
        @secret = secret
    end

    def test_authentication 
        uri = URI.parse("https://api.pinata.cloud/data/testAuthentication")
        request = Net::HTTP::Get.new(uri)
        request["pinata_api_key"] = @key
        request["pinata_secret_api_key"] = @secret

        req_options = {
            use_ssl: uri.scheme == "https",
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
        end

        payload = {
            :code => response.code,
            :body => response.body 
        }

        return payload
    end
end