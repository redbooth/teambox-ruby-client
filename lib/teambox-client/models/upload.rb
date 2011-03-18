module Teambox
  class Upload < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def project
      get_reference('Project', @data, 'project_id', 'project')
    end
    
    def page
      get_reference('Project', @data, 'project_id', 'project')
    end
    
    def page_slot
      get_reference('PageSlot', @data, 'page_slot_id', 'page_slot')
    end
    
    def comment
      get_reference('Comment', @data, 'comment_id', 'comment')
    end
    
    def url #:nodoc:
      "/projects/#{@data['project_id']}/#{@data['id']}"
    end
  end
end
