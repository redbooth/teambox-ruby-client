module Teambox
  class PageSlot < Teambox::Resource
    def page
      get_reference('Page', @data, 'page_id', 'page')
    end
    
    def rel_object
      get_reference(@data['rel_object_type'], @data, 'rel_object_id', 'rel_object')
    end
    
    def url #:nodoc:
      nil
    end
  end
end