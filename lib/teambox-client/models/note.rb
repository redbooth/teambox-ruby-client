module Teambox
  class Note < Teambox::Resource
    def page
      get_or_make_reference('Page', @data, 'page_id')
    end
    
    def project
      get_or_make_reference('Project', @data, 'project_id')
    end
    
    def url #:nodoc:
      "/pages/#{@data['page_id']}/notes/#{@data['id']}"
    end
  end
end