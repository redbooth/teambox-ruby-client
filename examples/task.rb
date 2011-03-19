require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'teambox-client')
require 'pp'

TEAMBOX_SERVER = ENV["TEAMBOX_SERVER"] || "http://localhost:3000"

client = Teambox::Client.new({:base_uri => "#{TEAMBOX_SERVER}/api/1", :auth => {:user => 'frank', :password => 'papapa'}})
project = client.project('earthworks')

# Make a task list with a task, update task to hold
task_list = project.create_task_list(:name => 'Teambox App')
task = project.create_task(task_list, {:name => 'Decide what we are going to make'})
task.status_name = :hold
task.comment = "We have no idea what we are making!"
task.save
pp task.data
pp task.comments[0].data
