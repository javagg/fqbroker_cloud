require 'openshift-origin-controller'
require 'rails'
require 'httpclient'

module OpenShift   if defined?(Rails) && Rails::VERSION::MAJOR >= 3
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
        raise Exception.new('DNSPod DNS service is not initialized')
      end
      @login_email = access_info[:dnspod_login_email]
      @login_password = access_info[:dnspod_login_password]

      # Cache the domain id
      @http = HTTPClient.new
      url = "https://dnsapi.cn/Domain.Info"
      params = common_params.merge({ :domain => @domain_suffix })
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
      # curl -X POST https://dnsapi.cn/Record.Create -d 'login_email=api@dnspod.com&login_password=password&format=json&domain_id=2317346&sub_domain=@&record_type=A&record_line=默认&value=1.1.1.1'

      # create an A record for the application in the domain
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

      result = JSON.parse(response.body)
      result.status['message']
      #{
      #    "status": {
      #    "code":"1",
      #    "message":"Action completed successful",
      #    "created_at":"2012-11-23 22:17:47"
      #},
      #    "record": {
      #    "id":"16894439",
      #    "name":"@",
      #    "status":"enable"
      #}
      #}

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
      # delete the CNAME record for the application in the domain
      fqdn = "#{app_name}-#{namespace}.#{@domain_suffix}"

      # Get the record you mean to delete.
      # We need the TTL and value to delete it.
      record = get_record(fqdn)

      # If record is nil, then we're done.  Raise an exception for trying?
      return if record == nil
      ttl = record[:ttl]
      public_hostname = record[:resource_records][0][:value]

      delete = {
        :comment => "Delete an application record for #{fqdn}",
        :changes => [change_record("DELETE", fqdn, @ttl, public_hostname)]
      }
      
      #res = r53.change_resource_record_sets({
      #                                        :hosted_zone_id => @aws_hosted_zone_id,
      #                                        :change_batch => delete
      #                                      })

      url = "https://dnsapi.cn/Record.Remove"

      h = HTTPClient.new()

      default_params = {
          :login_email => ""
      }
      params = {

      }.merge(default_params)

      res = h.post(url, params)
      status_code = JSON.parse(res.body)['status']['code']
      if status_code == '1'

      end
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
      # delete the CNAME record for the application in the domain
      fqdn = "#{app_name}-#{namespace}.#{@domain_suffix}"

      # Get the record you mean to delete.
      # We need the TTL and value to delete it.
      record = get_record(fqdn)

      # If record is nil, then we're done.  Raise an exception for trying?
      return if record == nil
      ttl = record[:ttl]
      old_public_hostname = record[:resource_records][0][:value]

      update = {
        :comment => "Update an application record for #{fqdn}",
        :changes => [change_record("DELETE", fqdn, @ttl, old_public_hostname),
                     change_record("CREATE", fqdn, @ttl, new_public_hostname)]
      }
      
      url = 'https://dnsapi.cn/Record.Modify'
      h = HTTPClient.new(url)
      params = {

      }.merge({})

      h.post(url, params)
      record = JSON.parse(res.body)['record']

      #res = r53.change_resource_record_sets({
      #                                        :hosted_zone_id => @aws_hosted_zone_id,
      #                                        :change_batch => update
      #                                      })

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

    # create a Route53 communications client.
    #
    # @return [AWS::Route53::Client]
    def dnspod()
      AWS::Route53.new(:access_key_id => @aws_access_key_id,
                       :secret_access_key => @aws_access_key).client
    end

    # Create an Route53 change record data structure
    #
    # @param [String] action "CREATE" or "DELETE"
    # @param [String] fqdn the fully qualified domain name of the record
    # @param [FixNum] ttl "time to live" in seconds
    # @param [String] value the fully qualified domain name of the app host
    # @return [Hash] a data structure suitable for use in a Route53 change
    #   request
    def change_record(action, fqdn, ttl, value)
      # the CNAME values must be quoted
      {
        :action => action,
        :resource_record_set => {
          :name => fqdn,
          :type => "CNAME",
          :ttl => ttl,
          :resource_records => [{:value => value}],
        }
      }
    end
        
    # Retrieve a record from the AWS Route53 service
    # 
    # @param [String] fqdn The fully qualified domain name of an application
    # @return [nil|Hash] Return nil or a hash containing the requested record
    def get_record(fqdn)

      url = "https://dnsapi.cn/Record.List"

      h = HTTPClient.new()

      default_params = {
        :login_email => ""
      }
      params = {

      }.merge(default_params)

      res = h.post(url, params)
      records = JSON.parse(res.body)['records']


      # Request a single record "starting with" the desired record.
      #reply = r53.list_resource_record_sets(
      #          :hosted_zone_id => @aws_hosted_zone_id,
      #          :start_record_name => fqdn,
      #          :max_items => 1
      #      )


      # If the returned record name matches exactly, return it.
      # record fqdn are returned with the trailing anchor (.)
      return nil if not reply

      # Check if we found it exactly
      res = reply[:resource_record_sets][0]
      return nil if not res

      return res if res[:name] == fqdn + "."

      # If not, then you got nothing or a record which didn't match.
      nil
    end

    def common_params
      {
        :login_email => @login_email,
        :login_password => @login_password,
        :format => 'json'
      }
    end
  end
end

OpenShift::DnsService.provider=OpenShift::DnsPodPlugin

