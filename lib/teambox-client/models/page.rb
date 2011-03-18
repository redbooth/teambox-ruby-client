module Teambox
  class Page < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def project
      get_reference('Project', @data, 'project_id', 'project')
    end
    
    def url #:nodoc:
      "/projects/#{@data['project_id']}/#{@data['id']}"
    end
  end
end