require "httparty"
require "json"
require "oauth2"
require "uri"


directory = File.expand_path(File.dirname(__FILE__))
%w(teambox_oauth reference_list teambox result_set).each { |lib| require File.join(directory, 'teambox-client', lib) }
