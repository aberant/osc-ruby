require 'rubygems'
require 'spec'
require 'rr'

require 'osc'

Spec::Runner.configure do |config|
    config.mock_with RR::Adapters::Rspec
end