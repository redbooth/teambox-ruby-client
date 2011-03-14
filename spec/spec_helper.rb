require 'lib/teambox-client'

TEAMBOX_SERVER = ENV["TEAMBOX_SERVER"] || "http://localhost:3000"

def make_teambox_client(user='frank')
  Teambox::Client.new({:base_uri => "#{TEAMBOX_SERVER}/api/1", :auth => {:user => user, :password => 'papapa'}})
end
