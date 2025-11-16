# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "python-osc",
# ]
# ///


"""Example OSC server
Please run me via: `uv run integration-test/python/server.py`
This program listens to several addresses, and prints some information about
received packets.
"""
import argparse
import math

from pythonosc.dispatcher import Dispatcher
from pythonosc import osc_server

def print_osc(addr, *args):
    print(f"addr: {addr} -- args: {args}")

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--ip",
      default="127.0.0.1", help="The ip to listen on")
  parser.add_argument("--port",
      type=int, default=3333, help="The port to listen on")
  args = parser.parse_args()

  dispatcher = Dispatcher()
  dispatcher.map("/*", print_osc)

  server = osc_server.ThreadingOSCUDPServer(
      (args.ip, args.port), dispatcher)

  print("Serving on {}".format(server.server_address))
  server.serve_forever()
