require './lib/pinata'
require 'yaml'

# for local development only
config = YAML.load(
    File.open('config/config.yml').read
)
k = config['pinata-api-key']
s = config['pinata-api-secret']

pnt = Pinata.new(k,s)

print pnt.test_authentication

