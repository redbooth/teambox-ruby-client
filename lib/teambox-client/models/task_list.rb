module Teambox
  class TaskList < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def url
      "/task_lists/#{@data['id']}"
    end
  end
end