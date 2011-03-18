module Teambox
  class Project < Teambox::Resource
    # Teambox::User who created this project
    def owner_user
      get_reference('User', @data, 'owner_user_id', 'owner_user')
    end
    
    def url #:nodoc:
      "/projects/#{@data['permalink']||@data['id']}"
    end
    
    # Returns a Teambox::ResultSet of conversations in this project
    def conversations(query=nil)
      @list.client.get("#{url}/conversations", query)
    end
    
    # Returns a Teambox::ResultSet of task lists in this project
    def task_lists(query=nil)
      @list.client.get("#{url}/task_lists", query)
    end
    
    # Returns a Teambox::ResultSet of tasks in this project
    def tasks(query=nil)
      @list.client.get("#{url}/tasks", query)
    end
    
    # Returns a Teambox::ResultSet of comments in this project
    def comments(query=nil)
      @list.client.get("#{url}/comments", query)
    end
    
    # Creates a new Teambox::Conversation in this project
    def create_conversation(opts={})
      @list.client.post("#{url}/conversations", opts)
    end
    
    # Creates a new Teambox::TaskList in this project
    def create_task_list(opts={})
      @list.client.post("#{url}/task_lists", opts)
    end
    
    # Creates a new Teambox::Task in this project
    def create_task(task_list, opts={})
      @list.client.post("#{url}/task_lists/#{task_list.id}/tasks", opts)
    end
    
    # Creates a new Teambox::Comment in target belonging to this project
    def create_comment(target, opts={})
      @list.client.post("#{url}/comments", opts.merge({'target_type' => target.class.to_s, 'target_id' => target.id}))
    end
  end
end