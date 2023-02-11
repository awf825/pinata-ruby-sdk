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
  pinata = Pinata.new
  context "API authentication: Custom Headers" do
    it "Friendly message and 200 status code returned from successful authentication by Pinata API." do 
      response = pinata.test_authentication
      expect(response).to include({
        :code => "200",
        :body => "{\"message\":\"Congratulations! You are communicating with the Pinata API!\"}"
      })
    end

    # it "Ugly message and 401 status code returned from unsuccessful authentication by Pinata API." do 
    #   pinata = Pinata.new
    #   payload = pinata.test_authentication
    #   expect(payload).to include({
    #     :code => "401",
    #     :body => "{\"error\":{\"reason\":\"INVALID_API_KEYS\",\"details\":\"Invalid API key provided\"}}"
    #   })
    # end
  end

  context "Should be able to pin json, and properly provide invalid responses." do
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    string = (0...50).map { o[rand(o.length)] }.join
    content = {
        :key => string
    }

    # it "should properly pin json when content and metadata are passed as arguments. Should be able to retrieve JSON with returned IPFS hash" do 
    #   name = (0...50).map { o[rand(o.length)] }.join
    #   metadata = {
    #     :name => name
    #   }
    #   response = pinata.pin_json(content, metadata)
    #   ipfs_hash = response["IpfsHash"]
    #   response = pinata.get_by_cid(ipfs_hash)
    #   expect(response["key"]).to eq (content[:key])
    # end

    it "should return false when content is empty." do
      metadata = {
          :name => 'name',
          :keyvalues => {
            :customKey => 'customValue',
            :customKey2 => 'customValue2'
          }
      }
      response = pinata.pin_json({}, metadata)
      expect(response).to be false
    end

    it "should return false when no name is passed to metadata object." do
      metadata = {
          :keyvalues => {
            :customKey => 'customValue',
            :customKey2 => 'customValue2'
          }
      }
      response = pinata.pin_json(content, metadata)
      expect(response).to be false
    end
  end

  context "should be able to query by name or CID." do 
    it "should return false if integer is passed to either query_by_name or query_by_cid" do 
      name_response = pinata.query_by_name(1)
      cid_response = pinata.get_by_cid(2)

      expect(name_response).to be false
      expect(cid_response).to be false
    end
  end
end