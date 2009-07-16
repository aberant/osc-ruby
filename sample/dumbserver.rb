# dumbserver.rb: Written by Tadayoshi Funaba 2005,2006
# $Id: dumbserver.rb,v 1.3 2006-03-11 10:03:36+09 tadf Exp $

require 'osc'
require 'gopt'
include  OSC

def usage
  warn 'usage: dumbserver [-l lport]'
  exit 1
end

usage unless opt = Gopt.gopt('l:')

lport = (opt[:l] || '10000').to_i

ss = SimpleServer.new(lport)
ss.add_method(nil) do |mesg|
  p [mesg.address, mesg.to_a]
end
ss.run
