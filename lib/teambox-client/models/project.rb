module Teambox
  class Project < Teambox::Resource
    def owner_user
      get_reference('User', @data, 'owner_user_id', 'owner_user')
    end
    
    def url
      "/projects/#{@data['permalink']||@data['id']}"
    end
  end
end