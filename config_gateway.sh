#!/bin/bash

gateway=$1

echo "Configure proxy using ${gateway}"

route add default gw ${gateway}
route del default gw 10.0.2.2