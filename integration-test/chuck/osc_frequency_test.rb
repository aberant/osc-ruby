system( "chuck --version &>/dev/null" )

# why does chuck say it's a failure when it successfully outputs the version?
if $?.exitstatus != 2 
  STDERR.puts "you must install ChucK for this test to work"
  exit 1
end
chuck_file = File.join(File.dirname(__FILE__), "simple_osc_synth.ck")

pid = fork do
  puts "child process"
  exec( "chuck #{chuck_file}" )
  exit
end
puts pid

# wait for chuck to wake up
sleep(0.1)

require 'osc-ruby'
@client = OSC::Client.new( 'localhost', 3333 )
(48..71).each do |midi_note|
  @client.send( OSC::Message.new("/foo/notes", midi_note, 0.2))
  sleep( 0.25 )
end

Process.kill("SIGTERM", pid)
