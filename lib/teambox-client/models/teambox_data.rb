module Teambox
  class TeamboxData < Teambox::Resource
    def user
      get_reference('User', @data, 'user_id', 'user')
    end
    
    # Time this data was processed
    def processed_at
      @data.has_key?('processed_at') ? Time.parse(data['processed_at']) : nil
    end
    
    def url #:nodoc:
      nil
    end
  end
end
