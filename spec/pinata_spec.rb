require 'pinata'

# N.B. run with these flags to get output: 
# rspec spec/pinata_spec.rb --format doc
#   or  
# bundle exec rspec --format doc

RSpec.describe Pinata do 
  it "returns initialized key when print_key called" do
    key = "xyz"
    pinata = Pinata.new(key)
    expect(pinata.print_key).to eq(key), "Initialized key returned when print_key called"
  end

    # context "when initialized with key 'xyz'" do
  #   it "returns initialized 'xyz' when print_key called" do
  #     key = "xyz"
  #     pinata = Pinata.new(key)
  #     expect(pinata.print_key).to eq(key), "Initialized key returned when print_key called"
  #   end
  # end
end