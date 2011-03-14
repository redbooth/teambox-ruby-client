module Teambox
  class Comment < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def target
      get_reference(@data['target_type'], @data, 'target_id', 'target')
    end
  end
end