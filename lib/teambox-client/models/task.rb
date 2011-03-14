module Teambox
  class Task < Teambox::Resource
    STATUS_NAMES = [:new, :open, :hold, :resolved, :rejected]
    STATUSES = [0,1,2,3,4]
    
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def task_list
      get_reference('TaskList', @data, 'task_list_id', 'task_list')
    end
    
    def assigned
      get_reference('Person', @data, 'assigned_id', 'assigned')
    end
    
    def assigned=(value)
      @data['assigned_id'] = set_reference('Person', value).id
    end
    
    def due_on(value)
      @data['due_on'] ? Date.parse(@data['due_on']) : nil
    end
    
    def due_on=(value)
      @data['due_on'] = value.strftime('%Y-%m-%d %H:%M:%S %z')
    end
    
    def comment=(value)
      @data['comment_attributes'] = {'0' => {'body' => value}}
    end
    
    def status_name
      STATUS_NAMES[@data['status']]
    end
    
    def status_name=(value)
      @data['status'] = STATUSES[value]
    end
    
    def url
      "/tasks/#{@data['id']}"
    end
  end
end