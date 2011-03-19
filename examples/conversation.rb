require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'teambox-client')
require 'pp'

TEAMBOX_SERVER = ENV["TEAMBOX_SERVER"] || "http://localhost:3000"

client = Teambox::Client.new({:base_uri => "#{TEAMBOX_SERVER}/api/1", :auth => {:user => 'frank', :password => 'papapa'}})
project = client.project('earthworks')

# Make a conversation
project.create_conversation({:body => 'Test conversation', :simple => true}) # return conversation resource
pp project.conversations[0].data
