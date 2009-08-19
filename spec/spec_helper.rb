require 'rubygems'
require 'spec'
require 'rr'

$:.unshift( File.join( File.dirname( __FILE__), '..', 'lib' ) ) 
$:.unshift( File.dirname( __FILE__ ) )

require 'osc-ruby'
require 'builders/message_builder'

Spec::Runner.configure do |config|
    config.mock_with RR::Adapters::Rspec
end 