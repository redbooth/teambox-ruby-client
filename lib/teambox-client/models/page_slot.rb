module Teambox
  class PageSlot < Teambox::Resource
    def page
      get_or_make_reference('Page', @data, 'page_id')
    end
    
    # The Teambox::Note, Teambox::Divider, or Teambox::Upload attached to this slot
    def rel_object
      get_or_make_reference(@data['rel_object_type'], @data, 'rel_object_id')
    end
    
    def url #:nodoc:
      nil
    end
  end
end