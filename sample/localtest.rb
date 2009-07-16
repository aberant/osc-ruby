# localtest.rb: Written by Tadayoshi Funaba 2005,2006
# $Id: localtest.rb,v 1.4 2006-11-10 21:54:30+09 tadf Exp $

require 'osc'
include  OSC

PORT = 10000

th = Thread.fork do
  ss = SimpleServer.new(PORT)
  ss.add_method('/foo/*') do |mesg|
    p [mesg.address, mesg.to_a]
    exit if mesg.address =~ /\/kill\z/
  end
  ss.run
end

sc = SimpleClient.new('localhost', PORT)

xs = []
xs << Bundle.new(Time.now + 10, Message.new('/foo/kill'))
xs << Bundle.new(Time.now +  5, Message.new('/foo/more'))
xs << Message.new('/foo/bar', nil, 1, 3.14, 'rikyu')
xs << Message.new('/foo/bar', nil, -2, 1.44, 'basho')
xs.each do |x|
  sc.send(x)
end

th.join
