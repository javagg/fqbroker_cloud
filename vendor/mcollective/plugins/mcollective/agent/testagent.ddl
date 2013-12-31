metadata :name => "Test Connector Agent",
         :description => "Agent to test connector functionality",
         :author => "Alex Lee",
         :license => "ASL 2.0",
         :version => "0.1",
         :url => "http://www.freequant.net",
         :timeout => 360

action "echo", :description => "echo's a string back" do
  display :always
  input :msg,
        :prompt => "prompt when asking for information",
        :description => "description of input",
        :type  => :string,
        :validation => '^.+$',
        :optional => false,
        :maxlength => 90

  output :msg,
         :description => "displayed message",
         :display_as => "Message"

  output :time,
         :description => "the time as a message",
         :display_as => "Time"
end
