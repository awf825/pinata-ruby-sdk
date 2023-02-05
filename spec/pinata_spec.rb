require 'pinata'
require 'yaml'

# N.B. run with these flags to get output: 
# rspec spec/pinata_spec.rb --format doc
#   or  
# bundle exec rspec --format doc

# for local development only
config = YAML.load(
  File.open('config/config.yml').read
)
k = config['pinata-api-key']
s = config['pinata-api-secret']

RSpec.describe Pinata do 
  context "API authentication" do
    it "Friendly message and 200 status code returned from successful authentication by Pinata API." do 
      pinata = Pinata.new(k,s)
      payload = pinata.test_authentication
      expect(payload).to include({
        :code => "200",
        :body => "{\"message\":\"Congratulations! You are communicating with the Pinata API!\"}"
      })
    end

    it "Ugly message and 401 status code returned from unsuccessful authentication by Pinata API." do 
      pinata = Pinata.new("invalidkey!",s)
      payload = pinata.test_authentication
      expect(payload).to include({
        :code => "401",
        :body => "{\"error\":{\"reason\":\"INVALID_API_KEYS\",\"details\":\"Invalid API key provided\"}}"
      })
    end
  end
end