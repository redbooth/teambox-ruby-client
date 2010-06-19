require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "teambox-client"
    gem.summary     = "A ruby gem wrapper for Teambox API"
    gem.description = "Provides methods to read and write to Teambox for ruby apps"
    gem.email       = "pablo@teambox.com"
    gem.homepage    = "http://github.com/micho/teambox-ruby"
    gem.authors     = ["Pablo Villalba", "John Nunemaker"]

    gem.add_dependency("hashie", "~> 0.2.0")
    gem.add_dependency("httparty", "~> 0.5.0")
    gem.add_dependency("yajl-ruby", "~> 0.7.0")

    #gem.add_development_dependency ""
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :test => :check_dependencies
task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "teambox-ruby #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
