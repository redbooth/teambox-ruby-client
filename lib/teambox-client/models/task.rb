module Teambox
  class Task < Teambox::Resource
    STATUS_NAMES = [:new, :open, :hold, :resolved, :rejected]
    STATUSES = [0,1,2,3,4]
    
    def user
      get_or_make_reference('User', @data, 'user_id')
    end
    
    # Teambox::TaskList this task belongs to
    def task_list
      get_or_make_reference('TaskList', @data, 'task_list_id')
    end
    
    # First Teambox::Comment of the task
    def first_comment
      get_or_make_reference('Comment', @data, 'first_comment_id')
    end
    
    # Last two Teambox::Comment of the task (may include first_comment)
    def recent_comments
      get_or_make_references('Comment', @data, 'recent_comment_ids')
    end
    
    # Gets a Teambox::ResultSet of all Teambox::Comment objects belonging to the conversation
    def comments
      @list.client.get("#{url}/comments")
    end
    
    # The Teambox::Person assigned this task
    def assigned
      get_or_make_reference('Person', @data, 'assigned_id')
    end
    
    # Sets the Teambox::Person assigned this task
    def assigned=(value)
      @data['assigned_id'] = set_reference('Person', value).id
    end
    
    # Current due date
    def due_on
      @data['due_on'] ? Date.parse(@data['due_on']) : nil
    end
    
    def due_on=(value)
      @data['due_on'] = value.strftime('%Y-%m-%d %H:%M:%S %z')
    end
    
    def comment=(value)
      @data['comments_attributes'] = {'0' => {'body' => value}}
    end
    
    # Current status
    def status_name
      STATUS_NAMES[@data['status']]
    end
    
    def status_name=(value)
      @data['status'] = STATUS_NAMES.index(value.to_sym)
    end
    
    def url #:nodoc:
      "/tasks/#{@data['id']}"
    end
  end
end