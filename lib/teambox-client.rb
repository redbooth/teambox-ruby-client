require "httparty"
require "json"

directory = File.expand_path(File.dirname(__FILE__))
%w(teambox result_set).each { |lib| require File.join(directory, 'teambox-client', lib) }
