module Teambox
  class Page < Teambox::Resource
    def user
      get_or_make_reference('User', @data, 'user_id')
    end
    
    def project
      get_or_make_reference('Project', @data, 'project_id')
    end
    
    # Returns an Array of Teambox::PageSlot
    def slots
      get_or_make_references('PageSlot', @data, 'slot_ids', 'slots')
    end
    
    def url #:nodoc:
      "/projects/#{@data['project_id']}/pages/#{@data['id']}"
    end
  end
end