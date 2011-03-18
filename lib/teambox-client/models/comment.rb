module Teambox
  class Comment < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    # The Teambox::Resource which this comment belongs to
    def target
      get_reference(@data['target_type'], @data, 'target_id', 'target')
    end
    
    def url #:nodoc:
      "/comments/#{@data['id']}"
    end
  end
end