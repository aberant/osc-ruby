#! /usr/bin/env ruby

# joy.rb: Written by Tadayoshi Funaba 2005
# $Id: joy.rb,v 1.2 2005-08-06 15:28:49+09 tadf Exp $

require 'osc'
require 'Win32API'
require 'gopt'
include  OSC

module OSC

  class WinMM < Win32API

    def initialize(proc, import, export)
      super('winmm', proc, import, export)
    end

  end

  module DevJoy

    @@GetNumDevs = WinMM.new('joyGetNumDevs', %w(), 'l')
    @@GetDevCaps = WinMM.new('joyGetDevCaps', %w(l p l), 'l')
    @@GetPos = WinMM.new('joyGetPos', %w(l p), 'l')

    def getnumdev() @@GetNumDevs.call end

    def getdevcaps(did)
      caps = "\000" * 404
      @@GetDevCaps.call(did, caps, caps.size)
      caps.unpack('S2Z32I19Z32Z260')
    end

    def getpos(did)
      info = "\000" * 16
      @@GetPos.call(did, info)
      info.unpack('I4')
    end

    module_function :getnumdev, :getdevcaps, :getpos

  end

end

def usage
  warn 'usage: joy [-h rhost] [-p rport]'
  exit 1
end

usage unless opt = Gopt.gopt('h:p:d:')

rhost = (opt[:h] || 'localhost')
rport = (opt[:p] || '10000').to_i
num = (opt[:d] || '0').to_i

sc = SimpleClient.new(rhost, rport)

loop do
  x, y, z, b = OSC::DevJoy.getpos(num)
  sc.send(Message.new('/joy/pos', 'f'*3,
		      x - (2**15-1),
		      y - (2**15-1),
		      z - (2**15-1)))
  sc.send(Message.new('/joy/buttons', 'f'*10,
		      (b >> 0) & 1,
		      (b >> 1) & 1,
		      (b >> 2) & 1,
		      (b >> 3) & 1,
		      (b >> 4) & 1,
		      (b >> 5) & 1,
		      (b >> 6) & 1,
		      (b >> 7) & 1,
		      (b >> 8) & 1,
		      (b >> 9) & 1))
  sleep 0.01
end
