# encoding: utf-8

require 'httpclient'
require 'json'
require 'uri'

module OpenShift
  class DnsLaPlugin < OpenShift::DnsService
    @oo_dns_provider = OpenShift::DnsLaPlugin

    # DEPENDENCIES
    # Rails.application.config.openshift[:domain_suffix]
    # Rails.application.config.dns[...]

    attr_reader :last_reply
    def initialize(access_info = nil)
      if access_info != nil
        @domain_suffix = access_info[:domain_suffix]
      elsif defined? Rails
        # extract from Rails.application.config[dns,ss]
        access_info = Rails.application.config.dns
        @domain_suffix = Rails.application.config.openshift[:domain_suffix]
      else
        raise Exception.new("DNSLA DNS service is not initialized")
      end
      uri = URI.parse(access_info[:dnsla_url])
      hostport = uri.host
      hostport += uri.port.to_s.length > 0 ? ":#{uri.port.to_s}" : ""
      user = uri.userinfo.split(':')[0]
      @api_base = "#{uri.scheme}://#{hostport}#{uri.path}"
      @apiid = uri.userinfo.split(':')[0]
      @apipass =  uri.userinfo.split(':')[1]

      # Get domain id
      @http = HTTPClient.new
      url = "#{@api_base}/domain.ashx"
      params = {
        :apiid => @apiid,
        :apipass => @apipass,
        :cmd => 'get',
        :rtype => 'json',
        :domain => @domain_suffix
      }
      res = @http.post(url, params)
      reply = JSON.parse(res.content)
      @domain_id = reply['data']['domainid']
      @last_reply = reply
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
      url = "#{@api_base}/record.ashx"
      params = common_params.merge({
        :cmd => 'create',
        :host => hostname,
        :recordtype => 'CNAME',
        :recordline => 'Def',
        :recorddata => public_hostname
      })
      res = @http.post(url, params)
      reply = JSON.parse(res.content)
      reply
    end

    # Unpublish an application - remove DNS record
    #
    # @param [String] app_name
    #   The name of the application to publish
    # @param [String] namespace
    #   The namespace which contains the application
    # @return [Object]
    #   The response from the service provider in what ever form
    #   that takes
    def deregister_application(app_name, namespace)
      fqdn = "#{app_name}-#{namespace}.#{@domain_suffix}"
      record = get_record(fqdn)
      return nil if record.nil?

      record_id = record['recordid']
      url = "#{@api_base}/record.ashx"
      params = common_params.merge({ :cmd => 'remove', :recordid => record_id })
      res = @http.post(url, params)
      reply = JSON.parse(res.content)
      reply
    end

    # Change the published location of an application - Modify DNS record
    #
    # @param [String] app_name
    #   The name of the application to publish
    # @param [String] namespace
    #   The namespace which contains the application
    # @param [String] public_hostname
    #   The name of the location where the application resides
    # @return [Object]
    #   The response from the service provider in what ever form
    #   that takes
    def modify_application(app_name, namespace, new_public_hostname)
      hostname = "#{app_name}-#{namespace}"
      fqdn = "#{app_name}-#{namespace}.#{@domain_suffix}"
      record = get_record(fqdn)
      return nil if record.nil?

      record_id = record['recordid']
      url = "#{@api_base}/record.ashx"
      params = common_params.merge({
        :cmd => 'edit',
        :recordid => record_id,
        :host => hostname,
        :recordtype => 'CNAME',
        :recordline => 'Def',
        :recorddata => new_public_hostname
      })
      res = @http.post(url, params)
      reply = JSON.parse(res.content)
      reply
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
      hostname = fqdn[0..-(".#{@domain_suffix}".length+1)]
      url = "#{@api_base}/record.ashx"
      params = common_params.merge({ :cmd => 'list' })
      res = @http.post(url, params)
      reply = JSON.parse(res.content)
      return nil unless reply
      return nil unless reply['datas']

      records = reply['datas']
      records.select! { |record|
        record['host'] == hostname
      }
      return records.first
    end

    # get common parameters for each request, used after initialization
    def common_params
       {
        :apiid => @apiid,
        :apipass => @apipass,
        :rtype => 'json',
        :domainid => @domain_id
       }
    end
  end
end
