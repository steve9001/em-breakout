# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "em-breakout/version"

Gem::Specification.new do |s|
  s.name        = "em-breakout"
  s.version     = EventMachine::Breakout::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Masterman"]
  s.email       = ["steve@vermonster.com"]
  s.homepage    = ""
  s.summary     = %q{Easy websockets server}
  s.description = %q{Easy websockets server}

  s.rubyforge_project = "em-breakout"

  s.add_dependency 'json', '>=1.4.6'
  s.add_dependency 'em-websocket', '>=0.2.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end



