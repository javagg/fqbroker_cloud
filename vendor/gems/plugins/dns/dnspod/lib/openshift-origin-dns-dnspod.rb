require 'openshift-origin-controller'
require 'rails'
require 'httpclient'

module OpenShift
  if defined?(Rails) && Rails::VERSION::MAJOR >= 3
    class DnsPodDnsEngine < Rails::Engine
    end
  end
end

module OpenShift
  class DnsPodPlugin < OpenShift::DnsService
    @oo_dns_provider = OpenShift::DnsPodPlugin

    # DEPENDENCIES
    # Rails.application.config.openshift[:domain_suffix]
    # Rails.application.config.dns[...]

    attr_reader :login_email, :login_password

    def initialize(access_info = nil)
      if access_info != nil
        @domain_suffix = access_info[:domain_suffix]
      elsif defined? Rails
        # extract from Rails.application.config[dns,ss]
        access_info = Rails.application.config.dns
        @domain_suffix = Rails.application.config.openshift[:domain_suffix]
      else
        raise Exception.new("DNSPod DNS service is not initialized")
      end

      @login_email = access_info[:dnspod_login_email]
      @login_password = access_info[:dnspod_login_password]

      # Get domain id
      @http = HTTPClient.new
      url = "https://dnsapi.cn/Domain.Info"
      params =  {
        :login_email => @login_email,
        :login_password => @login_password,
        :format => 'json',
        :domain => @domain_suffix
      }
      res = @http.post(url, params)
      @domain_id = JSON.parse(res.content)['domain']['id']
    end

    # Publish an application - create DNS record
    #
    # @param [String] app_name
    #   The name of the application to publish
    # @param [String] namespace
    #   The namespace which contains the application
    # @param [String] public_hostname
    #   The name of the location where the application resides
    # @return [Object]
    #   The result of the change request, including the request ID for
    #   polling the request status
    def register_application(app_name, namespace, public_hostname)
      hostname = "#{app_name}-#{namespace}"
      url = "https://dnsapi.cn/Record.Create"
      params = common_params.merge({
        :domain_id => @domain_id,
        :sub_domain => hostname,
        :record_type => 'A',
        :record_line => '默认',
        :value => public_hostname
      })
      res = @http.post(url, params)
      res = JSON.parse(res.content)
      puts res
    end

    # Publish an application - create DNS record
    #
    # @param [String] app_name
    #   The name of the application to publish
    # @param [String] namespace
    #   The namespace which contains the application
    # @param [String] public_hostname
    #   The name of the location where the application resides
    # @return [Object]
    #   The result of the change request, including the request ID for
    #   polling the request status
    def deregister_application(app_name, namespace)
      fqdn = "#{app_name}-#{namespace}.#{@domain_suffix}"
      record = get_record(fqdn)
      return if record == nil

      record_id = record['id']

      url = ' https://dnsapi.cn/Record.Remove'
      params = common_params.merge({ :record_id => record_id })
      res = @http.post(url, params)
      res = JSON.parse(res.contend)
      #res['status']['code'] == '1'
    end

    # Publish an application - create DNS record
    #
    # @param [String] app_name
    #   The name of the application to publish
    # @param [String] namespace
    #   The namespace which contains the application
    # @param [String] public_hostname
    #   The name of the location where the application resides
    # @return [Object]
    #   The result of the change request, including the request ID for
    #   polling the request status
    def modify_application(app_name, namespace, new_public_hostname)
      fqdn = "#{app_name}-#{namespace}.#{@domain_suffix}"
      record = get_record(fqdn)
      return if record == nil

      record_id = record['id']


      url = 'https://dnsapi.cn/Record.Modify'
      params = common_params.merge({ :record_id => record_id, :value => new_public_hostname })
      res = @http.post(url, params)
      res = JSON.parse(res.contend)
      #res['status']['code'] == '1'
    end

    # send any queued requests to the update server
    # @return [nil]
    def publish
    end

    # close any persistent connection to the update server
    # @return [nil]
    def close
    end
    
    private

    # Retrieve a record from the DNSPod service
    # 
    # @param [String] fqdn The fully qualified domain name of an application
    # @return [nil|Hash] Return nil or a hash containing the requested record
    def get_record(fqdn)
      hostname = fqdn.tr(".#{@domain_suffix}", "")
      url = 'https://dnsapi.cn/Record.List'
      params = common_params.merge({ :sub_domain => hostname })
      res = @http.post(url, params)
      res = JSON.parse(res.content)
      return nil if not res

      record = res['records'].first
      return nil if not record

      return record if record[:name] = hostname

      nil
    end

    # get common parameters for each request, used after initialization
    def common_params
      {
        :login_email => @login_email,
        :login_password => @login_password,
        :format => 'json',
        :domain_id => @domain_id
      }
    end
  end
end

OpenShift::DnsService.provider=OpenShift::DnsPodPlugin
