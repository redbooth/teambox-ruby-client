require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'teambox-client')
require 'pp'

client = Teambox::Client.new({:base_uri => 'http://localhost:4006/api/1', :auth => {:user => 'frank', :password => 'papapa'}})
pp client.current_user
