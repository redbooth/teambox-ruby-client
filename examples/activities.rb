require 'rubygems' # TODO: delete this
require File.join(File.dirname(__FILE__), '..', 'lib', 'teambox')
require File.join(File.dirname(__FILE__), 'helpers', 'config_store')
require 'pp'

config = ConfigStore.new("#{ENV['HOME']}/.teambox")
httpauth = Teambox::HTTPAuth.new(config['username'], config['password'])

client = Teambox::Base.new(httpauth)

client.activities.each do |activity|
  next unless activity["target"]
  case activity["target"]["type"]
  when "Comment"
    pp activity["target"]["comment"]["body"]
  end
end

client.activities_from_project("teambox").each do |activity|
  next unless activity["target"]
  case activity["target"]["type"]
  when "Comment"
    pp activity["target"]["comment"]["body"]
  end
end
