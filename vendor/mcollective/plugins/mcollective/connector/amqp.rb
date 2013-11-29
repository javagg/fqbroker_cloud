require 'bunny'
require 'monitor'

module MCollective
  module Connector
    # Handles sending and receiving messages over the AMQP 1.0 protocol
    #
    # This plugin requires the qpid-qmf bindings for ruby.
    #
    # Configuration options (non SSL):
    #   connector = qpid
    #   plugin.qpid.secure = false
    #   plugin.qpid.host = qpid server
    #   plugin.qpid.host.port = qpid port (default: 5672)
    #   plugin.qpid.timeout = qpid connection timeout in seconds (default: 5)
    #
    # Configuration options (SSL):
    #   connector = qpid
    #   plugin.qpid.secure = true
    #   plugin.qpid.ha_host = qpid server
    #   plugin.qpid.host.ha.port = qpid port (default: 5671)
    #   plugin.qpid.timeout = qpid connection timeout in seconds (default: 5)
    #
    class Amqp < Base
      attr_reader :connection

      def initialize
        @config = Config.instance
        @subscriptions = {}
        @base64 = false

        @buf = []
        @buf.extend(MonitorMixin)
        @empty_cond = @buf.new_cond

        @channel = nil
      end

      def connect
        Log.debug("Connection attempt to amqp server")
        if @connection
          Log.debug("Already connected. Not re-initializing connection")
          return
        end

        # Parse out the config info
        host = get_option("amqp.host", "127.0.0.1")
        port = get_option("amqp.port", 5672).to_i
        user = get_option("amqp.user")
        password = get_option("amqp.password")
        vhost = get_option("amqp.vhost")
        url = "amqp://#{user}:#{password}@#{host}:#{port}#{vhost}"
        ampq_options = {}

        @connection = nil
        begin
          Log.debug("Connecting to #{url}, #{ampq_options}")
          @connection = Bunny.new(url, ampq_options)
          @connection.start
        rescue Bunny::Exception => e
          Log.error("Initial connection failed... retrying")
          sleep 1
          retry
        end
        @channel = @connection.create_channel
        Log.info("AMQP Connection established")
      end

      def receive
        begin
          Log.debug("Waiting for a message...")
          msg = nil
          @buf.synchronize do
            @empty_cond.wait_while { @buf.empty? }
            msg = @buf.shift
          end
          Log.debug("Received message #{msg.inspect}")
        rescue Bunny::Exception => e
          Log.debug("Caught Exception #{e}")
          retry
        end
        Message.new(msg[:payload], msg, :base64 => @base64, :headers => {})
      end

      def publish(msg)
        Log.debug("Publish #{msg.inspect}")

        msg.base64_encode! if @base64
        raise "Cannot set specific reply to targets with the STOMP plugin" if msg.reply_to

        begin
          if msg.type == :direct_request
            msg.discovered_hosts.each do |node|
              target = make_target(msg.agent, msg.type, msg.collective, node)
              Log.debug("in send with #{target}")
              Log.debug("Sending a message to target '#{target}'")
              q = @channel.queue(target)
              q.publish msg.payload
             end
          else
            target = make_target(msg.agent, msg.type, msg.collective)
            q = @channel.queue(target)
            q.publish msg.payload
          end
          Log.debug("Message sent")
        rescue Bunny::Exception => e
          Log.debug("Caught Exception #{e}")
        end
      end

      # Subscribe to a topic or queue
      def subscribe(agent, type, collective)
        source = make_target(agent, type, collective)
        unless @subscriptions.has_key?(source)
          Log.debug("Subscribing to #{source}")
          queue = @channel.queue(source)
          queue.subscribe(:block => false) do |delivery_info, properties, payload|
            msg = { :delivery_info => delivery_info, :properties => properties, :payload => payload }
            @buf.synchronize do
              @buf.push(msg)
              @empty_cond.signal
            end
          end
          @subscriptions[source] = queue
        end
      end

      def unsubscribe(agent, type, collective)
        source = make_target(agent, type, collective)
        @subscriptions.delete(source)
        @channel.queue(source).delete
        Log.debug("Unsubscribing #{source}")
      end

      def target_for(msg, node=nil)
        if msg.type == :reply
          target = {:name => msg.request.headers["reply-to"], :headers => {}, :id => ""}
        elsif [:request, :direct_request].include?(msg.type)
          target = make_target(msg.agent, msg.type, msg.collective, node)
        else
          raise "Don't now how to create a target for message type #{msg.type}"
        end

        return target
      end

      def make_target(agent, type, collective, target_node=nil)
        raise("Unknown target type #{type}") unless [:directed, :broadcast, :reply, :request, :direct_request].include?(type)
        raise("Unknown collective '#{collective}' known collectives are '#{@config.collectives.join ', '}'") unless @config.collectives.include?(collective)

        prefix = @config.topicprefix

        case type
          when :reply
            suffix = :reply
          when :broadcast
            suffix = :command
          when :request
            suffix = :command
          when :direct_request
            agent = nil
            prefix = @config.queueprefix
            suffix = Digest::MD5.hexdigest(target_node)
          when :directed
            agent = nil
            prefix = @config.queueprefix
            # use a md5 since hostnames might have illegal characters that
            # the middleware dont understand
            suffix = Digest::MD5.hexdigest(@config.identity)
        end

        ["#{prefix}#{collective}", agent, suffix].compact.join(@config.topicsep)
      end

      def disconnect
        Log.debug("Disconnecting from Amqp Server")
        @connection.close
        @connection = nil
      end

      private

      # looks for a config option, accepts an optional default
      #raises an exception when it cant find a value anywhere
      def get_option(opt, default=nil, allow_nil=true)
        return @config.pluginconf[opt] if @config.pluginconf.include?(opt)
        return default if (default or allow_nil)
        raise("No plugin.#{opt} configuration option given")
      end
    end
  end
end
