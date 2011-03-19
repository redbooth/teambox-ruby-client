module Teambox
  class Conversation < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    # Last two Teambox::Comment of the conversation (may include first_comment)
    def recent_comments
      get_references('Comment', @data, 'recent_comment_ids', 'recent_comments')
    end
    
    # First Teambox::Comment of the conversation
    def first_comment
      get_reference('Comment', @data, 'first_comment_id', 'first_comment')
    end
    
    # Gets a Teambox::ResultSet of all Teambox::Comment objects belonging to the conversation
    def comments
      @list.client.get("#{url}/comments")
    end
    
    def url #:nodoc:
      "/conversations/#{@data['id']}"
    end
  end
end