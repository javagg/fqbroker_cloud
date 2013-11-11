#!/bin/bash -eu
CWD=`pwd`

if [ -z "$1" ]; then
  echo "Need origin-server source directory"
fi

ORIGIN_SERVER_SRC=$1
FQ_SERVER_SRC=$2

MSG_COMMON=$ORIGIN_SERVER_SRC/msg-common
mkdir -p msg-common/mcollective
cp -rf $MSG_COMMON/agent msg-common/mcollective

mkdir -p vendor/gems
for dir in common controller plugins/msg-broker/mcollective plugins/auth/mongo plugins/dns/nsupdate
do
  base_dir=$(dirname $dir)
  mkdir -p vendor/gems/$base_dir
  cp -r $ORIGIN_SERVER_SRC/$dir vendor/gems/$base_dir
  pushd vendor/gems/$dir
  gem_spec=$(ls *.gemspec)
  gem build $gem_spec
  gem spec *.gem -l --ruby > $gem_spec
  rm *.gem
  popd
done

# Our additional plugins
if [ ! -z "$FQ_SERVER_SRC" ]; then
  for dir in plugins/account/mongo
  do
    base_dir=$(dirname $dir)
    mkdir -p vendor/gems/$base_dir
    cp -r $FQ_SERVER_SRC/$dir vendor/gems/$base_dir
    pushd vendor/gems/$dir
    gem_spec=$(ls *.gemspec)
    gem build $gem_spec
    gem spec *.gem -l --ruby > $gem_spec
    rm *.gem
    popd
  done
fi
