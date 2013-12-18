namespace :mcollective do
  desc "Echo one of nodes"
  task :echo do
    cmd = %q(mco rpc openshift echo msg="hello, nodes" -c etc/mcollective/ali-client.cfg)
  end
end