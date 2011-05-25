module Teambox
  class TaskList < Teambox::Resource
    def user
      get_or_make_reference('User', @data, 'user_id')
    end
    
    # Time this task list commences
    def start_on
      @data.has_key?('start_on') ? Time.parse(data['start_on']) : nil
    end
    
    # Time this task list finished
    def finish_on
      @data.has_key?('finish_on') ? Time.parse(data['finish_on']) : nil
    end
    
    # Time this task list was completed
    def completed_at
      @data.has_key?('completed_at') ? Time.parse(data['completed_at']) : nil
    end
    
    def url #:nodoc:
      "/task_lists/#{@data['id']}"
    end
  end
end