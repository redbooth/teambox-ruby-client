module Teambox
  class Project < Teambox::Resource
    def owner_user
      get_reference('User', @data, 'owner_user_id', 'owner_user')
    end
    
    def url
      "/projects/#{@data['permalink']||@data['id']}"
    end
    
    def conversations(query=nil)
      @list.client.get("#{url}/conversations", query)
    end
    
    def task_lists(query=nil)
      @list.client.get("#{url}/task_lists", query)
    end
    
    def tasks(query=nil)
      @list.client.get("#{url}/tasks", query)
    end
    
    def comments(query=nil)
      @list.client.get("#{url}/comments", query)
    end
    
    def create_conversation(opts={})
      @list.client.post("#{url}/conversations", opts)
    end
    
    def create_task_list(opts={})
      @list.client.post("#{url}/task_lists", opts)
    end
    
    def create_task(task_list, opts={})
      @list.client.post("#{url}/task_lists/#{task_list.id}/tasks", opts)
    end
    
    def create_comment(target, opts={})
      @list.client.post("#{url}/comments", opts.merge({'target_type' => target.class.to_s, 'target_id' => target.id}))
    end
  end
end