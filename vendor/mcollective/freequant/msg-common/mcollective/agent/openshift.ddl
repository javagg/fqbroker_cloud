# This file should be referenced by libdir entry in /etc/mcollective/server.cfg
action "ide_do", :description => "run an ide action" do
  display :always

  input :action,
    :prompt         => "Action",
    :description    => "IDE hook to run",
    :type           => :string,
    :validation     => '^(restart|start|status|stop)$',
    :optional       => false,
    :maxlength      => 64

  input :args,
    :prompt         => "Args",
    :description    => "Args to pass to",
    :type           => :any,
    :optional       => true

  output :time,
    :description => "The time as a message",
    :display_as => "Time"

  output :output,
    :description => "Output from script",
    :display_as => "Output"

  output :exitcode,
    :description => "Exit code",
    :display_as => "Exit Code"
end

action "echox", :description => "echo's a string back" do
  display :always

  input :msg,
      :prompt         => "prompt when asking for information",
      :description    => "description of input",
      :type           => :string,
      :validation     => '^.+$',
      :optional       => false,
      :maxlength      => 90

  output  :msg,
          :description => "displayed message",
          :display_as => "Message"

  output  :time,
          :description => "the time as a message",
          :display_as => "Time"
end

