module Teambox
  class Organization < Teambox::Resource
    
    # Gets a Teambox::ResultSet of all Teambox::Project objects belonging to the organization
    def projects
      @list.client.get("#{url}/projects")
    end
    
    # Gets a Teambox::ResultSet of all Teambox::Membership objects belonging to the organization
    def memberships
      @list.client.get("#{url}/memberships")
    end
    
    def url #:nodoc:
      "/organizations/#{@data['permalink']||@data['id']}"
    end
  end
end