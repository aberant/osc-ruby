# osc.rb: Written by Tadayoshi Funaba 2005,2006
# $Id: osc.rb,v 1.4 2006-11-10 21:54:37+09 tadf Exp $

require 'forwardable'
require 'socket'
require 'thread'

$:.unshift( File.dirname( __FILE__ ) )


# jus the basics
require 'osc-ruby/osc_types'
require 'osc-ruby/packet'
require 'osc-ruby/osc_packet'
require 'osc-ruby/message'
require 'osc-ruby/bundle'
require 'osc-ruby/address_pattern'

# now we gettin fancy
require 'osc-ruby/simple_server'
require 'osc-ruby/simple_client'


