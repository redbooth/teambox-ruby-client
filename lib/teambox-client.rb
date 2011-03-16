require "httparty"
require "json"
require "oauth2"
require "uri"


directory = File.expand_path(File.dirname(__FILE__))
%w(teambox_oauth teambox result_set).each { |lib| require File.join(directory, 'teambox-client', lib) }
