`rm -f #{File.expand_path('../em-breakout.output', __FILE__)}`
CONTROL_SCRIPT = File.expand_path('../em_control', __FILE__)

module ServerHelper
  def restart_server
    #`#{::CONTROL_SCRIPT} stop ; EMDEBUG=true #{::CONTROL_SCRIPT} start`
    #`#{::CONTROL_SCRIPT} stop ; BDEBUG=true #{::CONTROL_SCRIPT} start`
    `#{::CONTROL_SCRIPT} stop ; #{::CONTROL_SCRIPT} start`
  end
  module_function :restart_server
end

World(ServerHelper)

ServerHelper.restart_server
at_exit do
  `#{CONTROL_SCRIPT} stop`
end
