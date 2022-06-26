#!/bin/bash
EXPOSED_PORT="$1"
while :;do
  nohup socat TCP-LISTEN:$EXPOSED_PORT,fork TCP:127.0.0.1:443
done
