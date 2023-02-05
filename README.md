# pinata-ruby-sdk
Creating SDK to interface with Pinata API (https://docs.pinata.cloud/pinata-api)

# Local Development

## Environment
Make a copy of config/config.example.yml and name in config.yml. This should remain in config/ (see .gitignore)

Place your api key and api secret in your newly created config file

## Running tests
After installing gems, from root of the file, run:

`
rspec spec/pinata_spec.rb --format doc
`

OR

`
bundle exec rspec --format doc
`