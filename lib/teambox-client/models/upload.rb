module Teambox
  class Upload < Teambox::Resource
    def user
      get_or_make_reference('User', @data, 'user_id')
    end
    
    def project
      get_or_make_reference('Project', @data, 'project_id')
    end
    
    def page
      get_or_make_reference('Project', @data, 'project_id')
    end
    
    def page_slot
      get_or_make_reference('PageSlot', @data, 'page_slot_id')
    end
    
    def comment
      get_or_make_reference('Comment', @data, 'comment_id')
    end
    
    def url #:nodoc:
      "/projects/#{@data['project_id']}/#{@data['id']}"
    end
  end
end
