module Teambox
  class Membership < Teambox::Resource
    def user
      get_or_make_reference('User', @data, 'user_id')
    end
    
    def organization
      get_or_make_reference('Organization', @data, 'organization_id')
    end
    
    def url #:nodoc:
      "/organizations/#{@data['organization_id']}/memberships/#{@data['id']}"
    end
  end
end