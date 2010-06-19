require File.join(File.dirname(__FILE__), '..', 'lib', 'teambox')
require File.join(File.dirname(__FILE__), 'helpers', 'config_store')
require 'pp'

httpauth = Teambox::HTTPAuth.new(TEAMBOX_USERNAME, TEAMBOX_PASSWORD)
client = Teambox::Base.new(httpauth)

pp client.user("pablo")

# TODO: Get a non-existant user