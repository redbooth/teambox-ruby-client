
This is a Ruby wrapper for Teambox API.

Largely inspired by the philosophy of KISS.
This is currently in development, and is missing many methods.

Get started
-------------------------------------------------------------------------------

First, install the *teambox-client* gem:

    gem install teambox-client

Now, run `irb -rubygems` and this snippet to get the list of activities:

    require 'teambox-client'
    client = Teambox::Client.new(:auth => {:username => 'frank', :password => 'papapa'})
    puts client.activities

By default, *teambox-client* will connect to the hosted service at [teambox.com](https://teambox.com/api/1), optionally you can:

    client = Teambox::Client.new(:base_uri => 'http://teambox.mysite.com/api/1', :auth => {:username => 'frank', :password => 'papapa'})

Examples
-------------------------------------------------------------------------------

See the examples directory.
