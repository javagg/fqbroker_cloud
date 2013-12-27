require 'openshift-origin-controller'
require 'rails'
require 'httpclient'

module OpenShift
  if defined?(Rails) && Rails::VERSION::MAJOR >= 3
    class DnsPodDnsEngine < Rails::Engine
    end
  end
end

require 'openshift/dnspod_plugin'
OpenShift::DnsService.provider=OpenShift::DnsPodPlugin
