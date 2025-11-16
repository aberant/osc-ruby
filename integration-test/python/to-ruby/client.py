# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "python-osc",
# ]
# ///

from pythonosc.udp_client import SimpleUDPClient
from pythonosc import osc_message_builder as msg_builder
from pythonosc import osc_bundle_builder as bundle_builder

ip = "127.0.0.1"
port = 3333

client = SimpleUDPClient(ip, port)

client.send_message("/test", [123])
client.send_message("/test", [3.14])
builder = msg_builder.OscMessageBuilder(address="/test")
builder.add_arg(3.14159265358979, builder.ARG_TYPE_DOUBLE)
client.send(builder.build())
client.send_message("/test", ["Hello, World!"])
client.send_message("/test", [None])
client.send_message("/test", [True])
client.send_message("/test", [False])


bundle = bundle_builder.OscBundleBuilder(bundle_builder.IMMEDIATELY)
int_builder = msg_builder.OscMessageBuilder(address="/test")
int_builder.add_arg(123)
float_builder = msg_builder.OscMessageBuilder(address="/test")
float_builder.add_arg(3.14)
string_builder = msg_builder.OscMessageBuilder(address="/test")
string_builder.add_arg("Bundle")
nil_builder = msg_builder.OscMessageBuilder(address="/test")
nil_builder.add_arg(None)
true_builder = msg_builder.OscMessageBuilder(address="/test")
true_builder.add_arg(True)
false_builder = msg_builder.OscMessageBuilder(address="/test")
false_builder.add_arg(False)

bundle.add_content(int_builder.build())
bundle.add_content(float_builder.build())
bundle.add_content(string_builder.build())
bundle.add_content(nil_builder.build())
bundle.add_content(true_builder.build())
bundle.add_content(false_builder.build())

output = bundle.build()
client.send(output)