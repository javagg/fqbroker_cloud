#!/bin/bash -e
CWD=`pwd`

if [ -z "$1" ]; then
  echo "Need origin-server source directory"
fi

ORIGIN_SERVER_SRC=$1
FQ_SERVER_SRC=$2

MSG_COMMON=$ORIGIN_SERVER_SRC/msg-common
mkdir -p msg-common/mcollective
cp -r $MSG_COMMON/agent msg-common/mcollective

mkdir -p $CWD/vendor/cache

for dir in common controller plugins/msg-broker/mcollective plugins/auth/mongo plugins/dns/nsupdate admin-console
do
  pushd $ORIGIN_SERVER_SRC/$dir
  gem build *.gemspec
  mv *.gem $CWD/vendor/cache
  popd
done

if [ ! -z "$FQ_SERVER_SRC" ]; then
  for dir in plugins/account/mongo
  do
    pushd $FQ_SERVER_SRC/$dir
    gem build *.gemspec
    mv *.gem $CWD/vendor/cache
    popd
  done
fi




