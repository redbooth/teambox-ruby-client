module Teambox
  class Note < Teambox::Resource
    def page
      get_reference('Page', @data, 'page_id', 'page')
    end
    
    def url #:nodoc:
      "/pages/#{@data['page_id']}/notes/#{@data['id']}"
    end
  end
end