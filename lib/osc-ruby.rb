# osc.rb: Written by Tadayoshi Funaba 2005,2006
# $Id: osc.rb,v 1.4 2006-11-10 21:54:37+09 tadf Exp $

require 'forwardable'
require 'socket'
require 'thread'
require 'monitor'


$:.unshift( File.dirname( __FILE__ ) )

# core extensions
require 'osc-ruby/core_ext/object'
require 'osc-ruby/core_ext/numeric'
require 'osc-ruby/core_ext/time'


# jus the basics
require 'osc-ruby/message_queue'
require 'osc-ruby/osc_types'
require 'osc-ruby/packet'
require 'osc-ruby/osc_packet'
require 'osc-ruby/message'
require 'osc-ruby/bundle'
require 'osc-ruby/address_pattern'

# now we gettin fancy
require 'osc-ruby/simple_server'
require 'osc-ruby/simple_client'


