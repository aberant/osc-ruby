# send.rb: Written by Tadayoshi Funaba 2005,2006
# $Id: send.rb,v 1.3 2006-11-12 23:37:17+09 tadf Exp $

require 'osc'
require 'readline'
require 'gopt'
include  OSC

def usage
  warn 'usage: send [-h rhost] [-p rport]'
  exit 1
end

usage unless opt = Gopt.gopt('h:p:')

rhost = (opt[:h] || 'localhost')
rport = (opt[:p] || '10000').to_i

sc = SimpleClient.new(rhost, rport)

loop do
  begin
    mesg = Readline.readline('? ', true)
    break if mesg == nil || mesg == '.'
    args = mesg.split
    address = args.shift
    if args[0] && args[0][0] == ?,
      tags = args.shift[1..-1]
    end
    args.each_with_index do |arg, i|
      if tags && tags[i]
	case tags[i,1]
	when 'i'; args[i] = OSCInt32.new(arg.to_i)
	when 'f'; args[i] = OSCFloat32.new(arg.to_f)
	when 's'; args[i] = OSCString.new(arg)
	when 'b'; args[i] = OSCBlob.new(arg)
	else; raise ArgumentError, 'unknown type'
	end
      else
	case arg
	when /\A[-+]?\d+\z/; args[i] = OSCInt32.new(arg.to_i)
	when /\A[-+]?\d+\./; args[i] = OSCFloat32.new(arg.to_f)
	else;                args[i] = OSCString.new(arg)
	end
      end
    end
    if address
      sc.send(Message.new(address, nil, *args))
    end
  rescue
    warn $!
  end
end
