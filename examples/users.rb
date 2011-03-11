require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'teambox-client')
require 'pp'

client = Teambox::Client.new({:base_uri => 'http://localhost:4006/api/1', :auth => {:user => 'frank', :password => 'papapa'}})
puts "Logged in as #{client.current_user.name} (#{client.current_user.username})"

# Get info on single project
project = client.get("/projects/earthworks")
puts "Earthworks owner: #{client.get('/projects/earthworks').owner_user.reload.name}"

# Get info on all projects (subject to limits)
client.get('/projects').each do |project|
  puts "Project: #{project.name} (#{project.permalink})"
  puts "  Owned by: #{project.owner_user.name}"
end

