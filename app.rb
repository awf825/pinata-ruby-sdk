require './lib/pinata'
require 'yaml'

# for local development only
config = YAML.load(
    File.open('config/config.yml').read
)
k = config['pinata-api-key']
s = config['pinata-api-secret']
jwt = config['pinata-jwt']

# pnt = Pinata.new(k,s)

pnt = Pinata.new

# print pnt.test_authentication

# content = {
#     :somekey => 'somevalue6'
# }
# metadata = {
#     :name => 'testing6',
#     :keyvalues => {
#       :customKey => 1,
#       :customKey2 => 2
#     }
# }
# print pnt.pin_json(
#     content, 
#     metadata
# )

# print pnt.query_by_name('testing5')

print pnt.get_by_cid("bafkreiah76tkddnr2gwl2jjhn4cvqfuquvjkbscyvovvebrdohjbtm3a5m")

