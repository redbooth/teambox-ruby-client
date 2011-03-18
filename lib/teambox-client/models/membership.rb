module Teambox
  class Membership < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def organization
      get_reference('Organization', @data, 'organization_id', 'organization')
    end
    
    def url #:nodoc:
      "/organizations/#{@data['organization_id']}/memberships/#{@data['id']}"
    end
  end
end