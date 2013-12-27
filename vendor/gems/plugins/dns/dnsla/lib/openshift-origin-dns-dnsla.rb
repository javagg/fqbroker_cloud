require 'openshift-origin-controller'
require 'rails'

module OpenShift
  if defined?(Rails) && Rails::VERSION::MAJOR >= 3
    class DnsLaDnsEngine < Rails::Engine
    end
  end
end

require 'openshift/dnsla_plugin'
OpenShift::DnsService.provider=OpenShift::DnsLaPlugin
