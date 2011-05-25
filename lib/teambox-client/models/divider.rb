module Teambox
  class Divider < Teambox::Resource
    def page
      get_or_make_reference('Page', @data, 'page_id')
    end
    
    def project
      get_or_make_reference('Project', @data, 'project_id')
    end
    
    def url #:nodoc:
      "/pages/#{@data['page_id']}/dividers/#{@data['id']}"
    end
  end
end