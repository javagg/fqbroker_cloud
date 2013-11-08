#!/bin/bash -e
CWD=`pwd`

if [ -z "$1" ]; then
  echo "Need origin-server source directory"
fi

ORIGIN_SERVER_SRC=$1
FQ_SERVER_SRC=$2

MSG_COMMON=$ORIGIN_SERVER_SRC/msg-common
mkdir -p msg-common/mcollective
cp -rf $MSG_COMMON/agent msg-common/mcollective

mkdir -p $CWD/vendor/cache

for dir in common controller plugins/msg-broker/mcollective plugins/auth/mongo plugins/dns/nsupdate
do
  pushd $ORIGIN_SERVER_SRC/$dir
  gem build *.gemspec
  mv -f *.gem $CWD/vendor/cache
  popd
done


# Patch it, remove therubyracer gem dependency
cp -rf $ORIGIN_SERVER_SRC/admin-console /tmp
ADMIN_CONSOLE_BUILD_DIR=/tmp/admin-console
pushd $ADMIN_CONSOLE_BUILD_DIR
sed -i -e "/s.add_dependency 'therubyracer'/d"  $ADMIN_CONSOLE_BUILD_DIR/openshift-origin-admin-console.gemspec
gem build *.gemspec
mv -f *.gem $CWD/vendor/cache
popd
rm -rf $ADMIN_CONSOLE_BUILD_DIR

# Our additional plugins
if [ ! -z "$FQ_SERVER_SRC" ]; then
  for dir in plugins/account/mongo
  do
    pushd $FQ_SERVER_SRC/$dir
    gem build *.gemspec
    mv -f *.gem $CWD/vendor/cache
    popd
  done
fi




