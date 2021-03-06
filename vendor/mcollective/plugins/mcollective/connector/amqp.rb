require 'bunny'
require 'monitor'

module MCollective
  module Connector
    class Amqp < Base
      attr_reader :connection

      def initialize
        @config = Config.instance
        @subscriptions = []
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
        url = "amqp://"
        url += "#{user}:#{password}@" unless user.nil? or password.nil?
        url += "#{host}:#{port}"
        url += "#{vhost}" unless vhost.nil?
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
        Message.new(msg[:payload], msg, :base64 => @base64)
      end

      def publish(msg)
        Log.debug("Publish #{msg.inspect}")
        msg.base64_encode! if @base64

        raise "Cannot set specific reply to targets with the AMQP plugin" if msg.reply_to

        target = make_target(msg.agent, msg.type, msg.collective)
        Log.debug("Sending a broadcast message to AMQP target '#{target}'")
        q = @channel.queue(target)
        q.publish msg.payload
      end

      # Subscribe to a topic or queue
      def subscribe(agent, type, collective)
        source = make_target(agent, type, collective)
        unless @subscriptions.include?(source)
          Log.debug("Subscribing to #{source}")
          queue = @channel.queue(source)
          queue.subscribe(:block => false) do |delivery_info, properties, payload|
            msg = { :delivery_info => delivery_info, :properties => properties, :payload => payload }
            @buf.synchronize do
              @buf.push(msg)
              @empty_cond.signal
            end
          end
          @subscriptions << source
        end
      end

      def unsubscribe(agent, type, collective)
        source = make_target(agent, type, collective)
        Log.debug("Unsubscribing #{source}")
        @channel.queue(source).delete
        @subscriptions.delete(source)
      end

      def disconnect
        Log.debug("Disconnecting from Amqp Server")
        @connection.close
        @connection = nil
      end

      def make_target(agent, type, collective)
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
            raise("Direct request not supported")
          when :directed
            raise("Directed not supported")
        end

        ["#{prefix}#{collective}", agent, suffix].compact.join(@config.topicsep)
      end

      private

      # looks for a config option, accepts an optional default
      #raises an exception when it cant find a value anywhere
      def get_option(opt, default=nil, allow_nil=true)
        return @config.pluginconf[opt] if @config.pluginconf.include?(opt)
        return default if (default or allow_nil)
        raise("No plugin.#{opt} configuration option given")
      end

      # gets a boolean option from the config, supports y/n/true/false/1/0
      def get_bool_option(opt, default)
        return default unless @config.pluginconf.include?(opt)

        val = @config.pluginconf[opt]

        if val =~ /^1|yes|true/
          return true
        elsif val =~ /^0|no|false/
          return false
        else
          return default
        end
      end
    end
  end
end
