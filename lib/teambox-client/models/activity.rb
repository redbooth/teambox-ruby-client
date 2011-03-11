module Teambox
  class Activity < Teambox::Resource
    
    def url
      "/activities/#{@data['id']}"
    end
  end
end