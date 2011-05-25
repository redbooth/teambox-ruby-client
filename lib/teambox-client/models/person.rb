module Teambox
  class Person < Teambox::Resource
    def user
      get_or_make_reference('User', @data, 'user_id')
    end
    
    def source_user
      get_or_make_reference('User', @data, 'source_user_id')
    end
    
    def project
      get_or_make_reference('Project', @data, 'project_id')
    end
    
    def url #:nodoc:
      "/projects/#{@data['project_id']}/people/#{@data['id']}"
    end
  end
end