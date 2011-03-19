module Teambox
  class Person < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def source_user
      get_reference('User', @data, 'source_user_id', 'source_user')
    end
    
    def project
      get_reference('Project', @data, 'project_id', 'project')
    end
    
    def url #:nodoc:
      "/projects/#{@data['project_id']}/people/#{@data['id']}"
    end
  end
end