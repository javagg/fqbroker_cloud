#!/bin/bash -eu
CWD=`pwd`

if [ -z "$1" ]; then
  echo "Need origin-server source directory"
fi

ORIGIN_SERVER_SRC=$1
FQ_SERVER_SRC=$2

rm -rf vendor/mcollective/origin
mkdir -p vendor/mcollective/origin/msg-common/mcollective/agent
cp -rf $ORIGIN_SERVER_SRC/msg-common/agent/openshift.ddl vendor/mcollective/origin/msg-common/mcollective/agent

rm -rf vendor/mcollective/freequant
mkdir -p vendor/mcollective/freequant/msg-common/mcollective/agent
cp -rf $FQ_SERVER_SRC/msg-common/agent/openshift.ddl vendor/mcollective/freequant/msg-common/mcollective/agent
mkdir -p vendor/mcollective/plugins/mcollective/connector
cp -rf $FQ_SERVER_SRC/deps/mcollective/connector/*.rb vendor/mcollective/plugins/mcollective/connector

# for connector testing
cp -rf $FQ_SERVER_SRC/deps/mcollective/test/testagent.* vendor/mcollective/plugins/mcollective/agent

rm -rf vendor/gems
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

# Patch it, remove therubyracer gem dependency
cp -rf $ORIGIN_SERVER_SRC/admin-console vendor/gems/admin-console
pushd vendor/gems/admin-console
sed -i -e "/s.add_dependency 'therubyracer'/d"  openshift-origin-admin-console.gemspec
gem_spec=$(ls *.gemspec)
gem build *.gemspec
gem spec *.gem -l --ruby > $gem_spec
rm *.gem
popd

# Our additional plugins
if [ ! -z "$FQ_SERVER_SRC" ]; then
  for dir in plugins/account/mongo plugins/dns/dnspod plugins/account/mongo plugins/dns/dnsla
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

# Patch mcollective
cp -rf $FQ_SERVER_SRC/msg-common/{agents_patch.rb,ddl_base_patch.rb} vendor/mcollective
