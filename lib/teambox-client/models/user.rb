module Teambox
  class User < Teambox::Resource
    def name
      "#{@data['first_name']} #{@data['last_name']}"
    end
  end
end