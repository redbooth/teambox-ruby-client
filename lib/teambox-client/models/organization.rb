module Teambox
  class Organization < Teambox::Resource
    def url #:nodoc:
      "/organizations/#{@data['permalink']||@data['id']}"
    end
  end
end