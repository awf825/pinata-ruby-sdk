require 'net/http'
require 'uri'
require 'json'

class Pinata
    def initialize()
        config = YAML.load(
            File.open('config/config.yml').read
        )
        # jwt should take precendence
        @auth = config['pinata-jwt'] ? {
            :token => config['pinata-jwt']
        } : {
            :key => config['pinata-api-key'],
            :secret => config['pinata-api-secret']
        }
    end 

    def test_authentication 
        uri = URI.parse("https://api.pinata.cloud/data/testAuthentication")
        req = Net::HTTP::Get.new(uri)
        
        if @auth[:token].nil?
            req["pinata_api_key"] = @auth[:key]
            req["pinata_secret_api_key"] = @auth[:secret]
        else
            req['Authorization'] = "Bearer #{@auth[:token]}"
        end

        req_options = {
            use_ssl: uri.scheme == "https",
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(req)
        end

        payload = {
            :code => response.code,
            :body => response.body 
        }

        return payload
    end

    #
    #   pin_json(
    #        content: { *any set of key value pairs* }
    #        metadata: { :name => String (required), :keyvalues => { ... :customKey => String, Int } (optional) }
    #   )
    #

    def pin_json(content, metadata)
        return false if metadata[:name].nil?
        return false if content.empty?
        uri = URI('https://api.pinata.cloud/pinning/pinJSONToIPFS')
        req = Net::HTTP::Post.new(uri)
        req.content_type = 'application/json'

        if @auth[:token].nil?
            req["pinata_api_key"] = @auth[:key]
            req["pinata_secret_api_key"] = @auth[:secret]
        else
            req['Authorization'] = "Bearer #{@auth[:token]}"
        end
        
        req.body = {
          :pinataOptions => {
            :cidVersion => 1
          },
          :pinataMetadata => metadata, 
          :pinataContent => content
        }.to_json
        
        req_options = {
            use_ssl: uri.scheme == 'https'
        }
        res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(req)
        end

        return JSON.parse(res.body)
    end

    def get_all_pinned
        uri = URI('https://api.pinata.cloud/data/pinList')
        params = {
            :status => 'pinned',
            :pinSizeMin => '100',
        }
        uri.query = URI.encode_www_form(params)

        req = Net::HTTP::Get.new(uri)

        if @auth[:token].nil?
            req["pinata_api_key"] = @auth[:key]
            req["pinata_secret_api_key"] = @auth[:secret]
        else
            req['Authorization'] = "Bearer #{@auth[:token]}"
        end

        req_options = {
            use_ssl: uri.scheme == 'https'
        }
        res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(req)
        end

        return JSON.parse(res.body)
    end

    # https://docs.pinata.cloud/pinata-api/data/query-files

    def query_by_name(name) 
        return false if name.class != String
        uri = URI("https://api.pinata.cloud/data/pinList?metadata[name]=#{name}")

        req = Net::HTTP::Get.new(uri)

        if @auth[:token].nil?
            req["pinata_api_key"] = @auth[:key]
            req["pinata_secret_api_key"] = @auth[:secret]
        else
            req['Authorization'] = "Bearer #{@auth[:token]}"
        end

        req_options = {
            use_ssl: uri.scheme == 'https'
        }
        res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(req)
        end

        return JSON.parse(res.body)
    end

    def get_by_cid(cid)
        return false if cid.class != String
        uri = URI("https://turtleverse.mypinata.cloud/ipfs/#{cid}")

        req = Net::HTTP::Get.new(uri)

        req_options = {
            use_ssl: uri.scheme == 'https'
        }
        res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(req)
        end

        return JSON.parse(res.body)
    end

    # def query_metadata(metadata)

    # end
end