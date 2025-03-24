#!/bin/bash

# Get the current machine's IP address on the 192.168.0.x network
if ip route | grep -q '192.168.0.'; then
  alias fs='ssh fs'
  alias ws='ssh ws'
  alias osmc='ssh ws'
fi
