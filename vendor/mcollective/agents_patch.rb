require 'mcollective'
require 'mcollective/agents'

# Force to load
MCollective::Agents

module MCollective
  class Agents
    alias original_loadagent loadagent
    def loadagent(agentname)
      original_loadagent(agentname)
      load_agent_exts(agentname)
    end

    private

    def load_agent_exts(agentname)
      find_agent_extfiles(agentname).each { |ext| require ext }
    end

    # searches the libdirs for agents
    def find_agent_extfiles(agentname)
      suffix = "_ext"
      extfiles = []
      @config.libdir.each do |libdir|
        extfile = File.join([libdir, "mcollective", "agent", "#{agentname}#{suffix}.rb"])
        if File.exist?(extfile)
          Log.debug("Found #{agentname} extension at #{extfile}")
          extfiles << extfile
        end
      end
      return extfiles
    end
  end
end


