require 'erb'

namespace :mcollective do
  desc "Generate mcollective-client configs"
  task :config do
    template = File.join(File.dirname(__FILE__), '..', '..', 'conf', 'mcollective', 'client.cfg.erb')
    message = ERB.new(IO.read(template))
    outfile = File.new(File.join(File.dirname(__FILE__), '..', '..', 'etc', 'mcollective', 'client.cfg'), "w")
    outfile.puts message.result
  end
end
