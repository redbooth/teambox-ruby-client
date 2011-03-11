module Teambox
  class User < Teambox::Resource
    def name
      "#{@data['first_name']} #{@data['last_name']}"
    end
    
    def url
      "/users/#{@data['id']}"
    end
  end
end