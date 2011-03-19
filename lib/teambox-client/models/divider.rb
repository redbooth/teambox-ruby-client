module Teambox
  class Divider < Teambox::Resource
    def page
      get_reference('Page', @data, 'page_id', 'page')
    end
    
    def project
      get_reference('Project', @data, 'project_id', 'project')
    end
    
    def url #:nodoc:
      "/pages/#{@data['page_id']}/dividers/#{@data['id']}"
    end
  end
end