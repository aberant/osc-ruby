# joy-test.rb: Written by Tadayoshi Funaba 2005
# $Id: joy-test.rb,v 1.2 2005-08-06 15:28:49+09 tadf Exp $

require 'osc'
require 'gopt'
include  OSC

def usage
  warn 'usage: joy-test [-h rhost] [-p rport]'
  exit 1
end

usage unless opt = Gopt.gopt('h:p:')

rhost = (opt[:h] || 'localhost')
rport = (opt[:p] || '10000').to_i

sc = SimpleClient.new(rhost, rport)

btns = [0] * 10
btns[0] = 1

sc.send(Message.new('/joy/buttons', 'f'*10, *btns))
(-2**15).step(2**15, 2**11) do |i|
  sc.send(Message.new('/joy/pos', 'f'*3, i, 0, 0))
  sleep 0.1
end
(-2**15).step(2**15, 2**11) do |i|
  sc.send(Message.new('/joy/pos', 'f'*3, 0, i, 0))
  sleep 0.1
end
sc.send(Message.new('/joy/pos', 'f'*3, 0, 0, 0))
(6..9).each do |i|
  btns[i] = 1
  sc.send(Message.new('/joy/buttons', 'f'*10, *btns))
  btns[i] = 0
  sleep 2.0
end
btns[4] = 1
sc.send(Message.new('/joy/buttons', 'f'*10, *btns))
sleep 2.0
btns = [0] * 10
sc.send(Message.new('/joy/buttons', 'f'*10, *btns))
