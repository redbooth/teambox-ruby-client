module Teambox
  class Invitation < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    # Teambox::User who is the subject of this invite
    def invited_user
      get_reference('User', @data, 'invited_user_id', 'invited_user')
    end
    
    # Teambox::Project the subject is being invited to
    def project
      get_reference('Project', @data, 'project_id', 'project')
    end
    
    def url #:nodoc:
      "/invitations/#{@data['id']}"
    end
  end
end