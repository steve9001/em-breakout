require 'rubygems'
require 'bundler/setup'
require 'timeout'
require 'breakout'

breakout_opts = {
  :worker_port => 8001,
  :browser_port => 8002
}

Before do
  Breakout.config(Breakout.random_config.merge(breakout_opts))
end
