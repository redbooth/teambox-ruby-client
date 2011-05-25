module Teambox
  class Activity < Teambox::Resource
    # Teambox::User who generated this activity
    def user
      get_or_make_reference('User', @data, 'user_id')
    end
    
    # The Teambox::Resource which generated this activity
    def target
      get_or_make_reference(@data['target_type'], @data, 'target_id')
    end
    
    # The Teambox::Project this activity belongs to
    def project
      get_or_make_reference('Project', @data, 'project_id')
    end
    
    # The target of the comment if this is a Teambox::Comment
    def comment_target
      get_or_make_reference(@data['comment_target_type'], @data, 'comment_target_id')
    end
    
    def url #:nodoc:
      "/activities/#{@data['id']}"
    end
  end
end