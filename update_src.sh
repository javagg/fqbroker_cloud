#!/bin/bash -e

if [ -z "$1" ]; then
  echo "Need origin-server source directory"
fi

ORIGIN_SERVER_SRC=$1
MSG_COMMON=$ORIGIN_SERVER_SRC/msg-common
mkdir -p msg-common/mcollective
cp -r $MSG_COMMON/agent msg-common/mcollective


