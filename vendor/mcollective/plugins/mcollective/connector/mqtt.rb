require 'mqtt'

module MCollective
  module Connector
    class Mqtt < Base
      attr_reader :connection
      def initialize
        @config = Config.instance
        @subscriptions = []
        @base64 = false
      end

      def connect
        Log.debug("Connection attempt to MQTT server")
        if @connection
          Log.debug("Already connection, not re-initializing connection")
          return
        end
        options = {}
        # Parse out the config info
        options['remote_host'] = get_option("mqtt.remote_host", "localhost")
        options['remote_port'] = get_option("mqtt.remote_port", 1883).to_i
        options['username'] = get_option("mqtt.username")
        options['password'] = get_option("mqtt.password")

        @connection = nil
        begin
          Log.debug("Connecting with #{options}")
          @connection = ::MQTT::Client.new(options)
          @connection.connect
        rescue MQTT::Exception => e
          raise("Could not connect to MQTT Server: #{e}")
        end
        Log.info("MQTT Connection established")
      end

      def disconnect
        Log.debug("Disconnecting from MQTT Server")
        @connection.disconnect
        @connection = nil
      end

      def receive
        Log.debug("Waiting for a message from MQTT")
        begin
          msg = @connection.get
        rescue ::MQTT::Exception
          sleep 1
          retry
        end
        Log.debug("Received message #{msg.inspect}")
        Message.new(msg[1], msg, :base64 => @base64)
      end

      def publish(msg)
        Log.debug("Publish #{msg.inspect}")
        msg.base64_encode! if @base64

        raise "Cannot set specific reply to targets with the MQTT plugin" if msg.reply_to

        target = make_target(msg.agent, msg.type, msg.collective)
        Log.debug("Sending a broadcast message to MQTT target '#{target}'")
        @connection.publish(target, msg.payload)
      end

      # Subscribe to a topic or queue
      def subscribe(agent, type, collective)
        source = make_target(agent, type, collective)
        unless @subscriptions.include?(source)
          Log.debug("Subscribing to #{source}")
          @connection.subscribe(source)
          @subscriptions << source
        end
      rescue
        Log.error("Received subscription request for #{source.inspect.chomp} but already had a matching subscription, ignoring")
      end

      def unsubscribe(agent, type, collective)
        source = make_target(agent, type, collective)
        @connection.subscribe(source)
        @subscriptions.delete(source)
        Log.debug("Unsubscribing #{source}")
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
