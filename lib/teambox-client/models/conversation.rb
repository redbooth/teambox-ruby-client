module Teambox
  class Conversation < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def recent_comments
      get_references('Comment', @data, 'recent_comment_ids', 'recent_comments')
    end
    
    def first_comment
      get_reference('Comment', @data, 'first_comment_id', 'first_comment')
    end
    
    def url #:nodoc:
      "/conversations/#{@data['id']}"
    end
  end
end