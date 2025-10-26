# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "python-osc",
# ]
# ///

from pythonosc.udp_client import SimpleUDPClient
from pythonosc import osc_message_builder

ip = "127.0.0.1"
port = 3333

client = SimpleUDPClient(ip, port)

client.send_message("/test", 123)
client.send_message("/test", 3.14)
builder = osc_message_builder.OscMessageBuilder(address="/test")
builder.add_arg(3.14159265358979, builder.ARG_TYPE_DOUBLE)
client.send(builder.build())
client.send_message("/test", "Hello, World!")
builder = osc_message_builder.OscMessageBuilder(address="/test")
builder.add_arg(None, builder.ARG_TYPE_NIL)
client.send(builder.build())
client.send_message("/test", True)
client.send_message("/test", False)
