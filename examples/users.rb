require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'teambox-client')
require 'pp'

TEAMBOX_SERVER = ENV["TEAMBOX_SERVER"] || "http://localhost:3000"

client = Teambox::Client.new({:base_uri => "#{TEAMBOX_SERVER}/api/1", :auth => {:user => 'frank', :password => 'papapa'}})
puts "Logged in as #{client.current_user.name} (#{client.current_user.username})"

# Get info on single project
project = client.project('earthworks')
puts "Earthworks owner: #{client.project('earthworks').owner_user.reload.name}"

# Get info on all projects (subject to limits)
client.projects.each do |project|
  puts "Project: #{project.name} (#{project.permalink})"
  puts "  Owned by: #{project.owner_user.name}"
end

#it's a very good project !!!!
