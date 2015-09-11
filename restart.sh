#!/bin/bash
cd $(dirname `readlink -f $0`)

. ./stop.sh
. ./start.sh
