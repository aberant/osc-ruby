# getmjd.rb: Written by Tadayoshi Funaba 2005
# $Id: getmjd.rb,v 1.2 2005-08-06 15:32:23+09 tadf Exp $

require 'osc'
require 'date'
require 'gopt'
include  OSC

class GetMJD

  def initialize(sc)
    @sc = sc
  end

  def accept(mesg)
    civil = mesg.collect{|x| x.to_i}
    begin
      mjd = Date.new(*civil).mjd
    rescue
      mjd = 0
    end
    @sc.send(Message.new('/getmjd/mjd', nil, mjd.to_f))
  end

end

def usage
  warn 'usage: getmjd [-h rhost] [-p rport] [-l lport]'
  exit 1
end

usage unless opt = Gopt.gopt('h:p:l:')

rhost = (opt[:h] || 'localhost')
rport = (opt[:p] || '10000').to_i
lport = (opt[:l] || rport).to_i

ss = SimpleServer.new(lport)
sc = SimpleClient.new(rhost, rport)
ss.add_method('/getmjd/civil', GetMJD.new(sc))
ss.run
