# encoding: utf-8

require 'httpclient'
require 'json'

module OpenShift
  class DnsPodPlugin < OpenShift::DnsService
    @oo_dns_provider = OpenShift::DnsPodPlugin

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
        raise Exception.new("DNSPod DNS service is not initialized")
      end

      url = access_info[:dnspod_url]
      puts url
      # Sadly, URI.parse can hanlde my account name
      # which is an email account with @ in it
      m = /(.*):\/\/(.*)/.match(url)
      schema = m[1]
      r = m[2]
      if idx = r.index("/")
        path = r[idx..-1]
        r = r[0..idx-1]
      else
        path = "/"
      end
      m = /(.*)@/.match(r)
      userpass = m[1]
      hostport = m.post_match

      if idx = userpass.index(":")
        user = userpass[0..idx-1]
        pass = userpass[idx+1..-1]
      else
        user = userpass
        pass = ""
      end

      if idx = hostport.index(":")
        host = hostport[0..idx-1]
        port = hostport[idx+1..-1]
      else
        host = hostport
        port = ""
      end

      path = path == '/' ? "" : path
      @api_base = "#{schema}://#{hostport}#{path}"
      @login_email = user
      @login_password = pass

      # Get domain id
      @http = HTTPClient.new
      url = "#{@api_base}/Domain.Info"
      params = {
        :login_email => @login_email,
        :login_password => @login_password,
        :format => 'json',
        :lang => 'en',
        :domain => @domain_suffix
      }
      res = @http.post(url, params)
      puts res
      reply = JSON.parse(res.content)
      puts reply
      @domain_id = reply['domain']['id']
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
      url = "#{@api_base}/Record.Create"
      params = common_params.merge({
        :domain_id => @domain_id,
        :sub_domain => hostname,
        :record_type => 'CNAME',
        :record_line => '默认',
        :value => public_hostname
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

      record_id = record['id']
      url = "#{@api_base}/Record.Remove"
      params = common_params.merge({ :record_id => record_id })
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

      record_id = record['id']
      url = "#{@api_base}/Record.Modify"
      params = common_params.merge({
        :record_id => record_id,
        :sub_domain => hostname,
        :record_type => 'CNAME',
        :record_line => '默认',
        :value => new_public_hostname
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
      url = "#{@api_base}/Record.List"
      params = common_params.merge({ :sub_domain => hostname })
      res = @http.post(url, params)
      reply = JSON.parse(res.content)

      return nil unless reply
      return nil unless reply['records']

      record = reply['records'].first
      return nil unless record

      return record if record[:name] = hostname

      nil
    end

    # get common parameters for each request, used after initialization
    def common_params
      {
        :login_email => @login_email,
        :login_password => @login_password,
        :format => 'json',
        :lang => 'en',
        :domain_id => @domain_id
      }
    end
  end
end
