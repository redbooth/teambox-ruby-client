module Teambox
  class PageSlot < Teambox::Resource
    def page
      get_reference('Page', @data, 'page_id', 'page')
    end
    
    # The Teambox::Note, Teambox::Divider, or Teambox::Upload attached to this slot
    def rel_object
      get_reference(@data['rel_object_type'], @data, 'rel_object_id', 'rel_object')
    end
    
    def url #:nodoc:
      nil
    end
  end
end