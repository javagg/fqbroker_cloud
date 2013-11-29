require 'mcollective'
require 'mcollective/ddl/base'
# Force to load
MCollective::DDL::Base

module MCollective
  module DDL
    class Base
      def loadddlfile
        ddlfiles = findddlfiles
        ddlfiles.each do |ddlfile|
          if ddlfile
            instance_eval(File.read(ddlfile), ddlfile, 1)
          else
            raise("Can't find DDL for #{@plugintype} plugin '#{@pluginname}'")
          end
        end
      end

      def findddlfiles(ddlname=nil, ddltype=nil)
        ddlname = @pluginname unless ddlname
        ddltype = @plugintype unless ddltype

        ddlfiles = []
        @config.libdir.each do |libdir|
          ddlfile = File.join([libdir, "mcollective", ddltype.to_s, "#{ddlname}.ddl"])
          if File.exist?(ddlfile)
            Log.debug("Found #{ddlname} ddl at #{ddlfile}")
            ddlfiles << ddlfile
          end
        end
        return ddlfiles
      end
    end
  end
end