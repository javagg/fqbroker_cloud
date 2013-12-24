require 'uri'
require 'openshift-origin-common'

namespace :'oo-admin' do
  # Need env MONGOLAB_URI and OPENSHIFT_CONF_DIR to be set
  desc "Reset admin password"
  task :'reset_admin_password' do
    uri = URI.parse(ENV['MONGOLAB_URI'])
    dbname = uri.path.start_with?('/') ? uri.path[1..-1] : uri.path
    configfile = File.join(ENV['OPENSHIFT_CONF_DIR'], 'broker.conf')
    config = ::OpenShift::Config.new(configfile)
    salt = config.get("AUTH_SALT")
    encoded_password = Digest::MD5.hexdigest(Digest::MD5.hexdigest("admin") + salt)
    mongo_cmd = "db.auth_user.update({\"_id\":\"admin\"}, {\"_id\":\"admin\",\"user\":\"admin\",\"password_hash\":\"#{encoded_password}\"}, true)"
    cmd = %Q(mongo #{dbname} --host #{uri.host} --port #{uri.port} --username #{uri.user} --password #{uri.password} --eval '#{mongo_cmd}')
    system(cmd)
  end
end

