module Teambox
  class Conversation < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
  end
end