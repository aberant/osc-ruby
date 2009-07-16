require 'rubygems'
require 'spec'
require 'rr'

$:.unshift( File.join( File.dirname( __FILE__), '..', 'lib' ) ) 

require 'osc-ruby'

Spec::Runner.configure do |config|
    config.mock_with RR::Adapters::Rspec
end 