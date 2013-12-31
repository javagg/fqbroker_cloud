require 'mcollective'

module MCollective
  module Agent
    class Testagent < RPC::Agent
      def echo_action
        validate :msg, String
        reply[:msg] = request[:msg]
      end
    end
  end
end
