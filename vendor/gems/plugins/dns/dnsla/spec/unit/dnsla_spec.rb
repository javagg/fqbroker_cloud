require 'rubygems'
require 'dnsruby'
require 'parseconfig'

# the plugin extends classes in the OpenShift::Controller module
# load the superclass for all DnsService classes: Openshift::DnsService
require 'openshift/dns_service'
require 'openshift/dnsla_plugin'

$test_accessurl = ENV['TEST_ACCESSURL']
$test_domain = ENV['TEST_DOMAIN']
$test_nodename1 = ENV['TEST_NODENAME1']
$test_nodename2 = ENV['TEST_NODENAME2']
$test_appname = "app1"
$test_namespace = "ns1"

#puts $test_accessurl

raise Exception.new("Missing required TEST_ACCESSURL") unless ENV['TEST_ACCESSURL']
raise Exception.new("Missing required TEST_DOMAIN") unless ENV['TEST_DOMAIN']
raise Exception.new("Missing required TEST_NODENAME1") unless ENV['TEST_NODENAME1']
raise Exception.new("Missing required TEST_NODENAME2") unless ENV['TEST_NODENAME2']

# Mock up the rails application configuration object
module Rails
  def self.application()
    Application.new
  end

  class Application
    class Configuration
      attr_accessor :openshift, :dns
      def initialize()
        @openshift = { :domain_suffix => $test_domain }
        @dns = { :dnsla_url => $test_accessurl }
      end
    end

    def config()
     Configuration.new
    end
  end
end

module OpenShift
  describe DnsLaPlugin do
    it "can function well with DNSLA" do
      dns_service = DnsLaPlugin.new()
      reply = dns_service.last_reply
      reply['status']['code'].should be == 300
      reply['data']['domainname'].should be == $test_domain

      reply = dns_service.register_application($test_appname, $test_namespace, $test_nodename1)
      reply['status']['code'].should be == 300

      reply = dns_service.modify_application($test_appname, $test_namespace, $test_nodename2)
      reply['status']['code'].should be == 300

      reply = dns_service.deregister_application($test_appname, $test_namespace)
      reply['status']['code'].should be == 300
    end
  end
end
