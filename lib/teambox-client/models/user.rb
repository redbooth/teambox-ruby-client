module Teambox
  class User < Teambox::Resource
    def name
      "#{@data['first_name']} #{@data['last_name']}"
    end
    
    def url #:nodoc:
      "/users/#{@data['id']}"
    end
  end
end