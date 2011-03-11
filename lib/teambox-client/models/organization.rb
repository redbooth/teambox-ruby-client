module Teambox
  class Organization < Teambox::Resource
    def url
      "/organizations/#{@data['permalink']||@data['id']}"
    end
  end
end