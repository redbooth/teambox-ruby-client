require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "teambox-client"
    gem.summary     = "A ruby gem wrapper for Teambox API"
    gem.description = "Provides methods to read and write to Teambox for ruby apps"
    gem.email       = "pablo@teambox.com"
    gem.homepage    = "http://github.com/teambox/teambox-ruby-client"
    gem.authors     = ["Pablo Villalba", "James Urquhart"]

    gem.add_dependency("httparty", "~> 0.7.4")
    gem.add_dependency("oauth2", "~> 0.1.1")
    gem.add_dependency("json", "~> 1.7.5")
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/*spec.rb"
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "teambox-client #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/**/*.rb')
end
