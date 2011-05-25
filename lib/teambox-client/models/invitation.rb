module Teambox
  class Invitation < Teambox::Resource
    def user
      get_or_make_reference('User', @data, 'user_id')
    end
    
    # Teambox::User who is the subject of this invite
    def invited_user
      get_or_make_reference('User', @data, 'invited_user_id')
    end
    
    # Teambox::Project the subject is being invited to
    def project
      get_or_make_reference('Project', @data, 'project_id')
    end
    
    def url #:nodoc:
      "/invitations/#{@data['id']}"
    end
  end
end