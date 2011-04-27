#!/usr/bin/env ruby

require 'rubygems'

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'em-breakout'

bdebug = ENV['BDEBUG']

EventMachine::Breakout.start_server(:bdebug => bdebug)
