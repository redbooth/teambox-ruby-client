module Teambox
  class Activity < Teambox::Resource
    # Teambox::User who generated this activity
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    # The Teambox::Resource which generated this activity
    def target
      get_reference(@data['target_type'], @data, 'target_id', 'target')
    end
    
    # The target of the comment if this is a Teambox::Comment
    def comment_target
      get_reference(@data['comment_target_type'], @data, 'comment_target_id', 'comment_target')
    end
    
    def url #:nodoc:
      "/activities/#{@data['id']}"
    end
  end
end