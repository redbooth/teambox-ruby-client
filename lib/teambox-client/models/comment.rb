module Teambox
  class Comment < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    def project
      get_reference('Project', @data, 'project_id', 'project')
    end
    
    # The Teambox::Resource which this comment belongs to
    def target
      get_reference(@data['target_type'], @data, 'target_id', 'target')
    end
    
    # The Teambox::Person assigned to the task at time of posting, if the comment belongs to a Teambox::Task
    def assigned
      get_reference('Person', @data, 'assigned_id', 'assigned')
    end
    
    # The Teambox::Person previously assigned to the task at time of posting, if the comment belongs to a Teambox::Task
    def previous_assigned
      get_reference('Person', @data, 'previous_assigned_id', 'previous_assigned')
    end
    
    # The name of the status assigned to the Teambox::Task at time of posting
    def status_name
      @data['status'].nil? ? nil : Teambox::Task::STATUS_NAMES[@data['status']]
    end
    
    # The name of the previous status assigned to the Teambox::Task at time of posting
    def previous_status_name
      @data['previous_status'].nil? ? nil : Teambox::Task::STATUS_NAMES[@data['previous_status']]
    end
    
    # The due date of the Teambox::Task at time of posting
    def due_on
      @data['due_on'] ? Time.parse(data['due_on']) : nil
    end
    
    # The previous due date of the Teambox::Task at time of posting
    def previous_due_on
      @data['previous_due_on'] ? Time.parse(data['previous_due_on']) : nil
    end
    
    # A list of Teambox::Upload attached to this comment
    def uploads
      get_references('Upload', @data, 'upload_ids', 'uploads')
    end
    
    def url #:nodoc:
      "/comments/#{@data['id']}"
    end
  end
end