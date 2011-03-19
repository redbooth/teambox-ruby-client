module Teambox
  class Page < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def project
      get_reference('Project', @data, 'project_id', 'project')
    end
    
    # Returns an Array of Teambox::PageSlot
    def slots
      get_references('PageSlot', @data, 'slot_ids', 'slots')
    end
    
    def url #:nodoc:
      "/projects/#{@data['project_id']}/pages/#{@data['id']}"
    end
  end
end