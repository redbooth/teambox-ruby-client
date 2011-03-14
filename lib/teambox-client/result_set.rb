module Teambox
  class ResultSet
    attr_reader :first_id, :last_id, :client, :references, :objects
    
    def initialize(client, request, objects, references)
      @client = client
      @request = request
      @objects = objects.map { |o| Teambox.create_model(o['type'], o, self) }
      @references = {}.tap { |h| references.each {|ref| h[ref['type'] + ref['id'].to_s] = Teambox.create_model(ref['type'], ref, self) } }
      
      id_list = objects.map{|obj| obj['id']}.sort
      @first_id = id_list[0]
      @last_id = id_list[-1]
    end
    
    def set_reference(klass, resource)
      real_resource = if resource.is_a? Teambox::Resource
        resource
      else
        Teambox.const_get(klass).new(resource, self)
      end
      
      @references[klass.to_s + real_resource.id.to_s] = real_resource
      real_resource
    end
    
    def set_references(klass, list)
      list.each { |o| set_reference(klass, o) }
    end
    
    def get_reference(klass, id)
      @references[klass.to_s + id]
    end
    
    def get_references(klass, ids)
      classname = klass.to_s
      ids.map{ |id| @references[classname + id] }.compact
    end
    
    def each(&block)
      @objects.each(&block)
    end
    
    def map(&block)
      @objects.map(&block)
    end
    
    def length
      @objects.length
    end
    
    def empty?
      @objects.length == 0
    end
    
    # get previous items
    def prev
      @client.get(@request[:url], {}, :query => (@request[:query]).merge(:max_id => @first_id))
    end
    
    # get next items
    def next
      @client.get(@request[:url], {}, :query => (@request[:query]).merge(:since_id => @last_id))
    end
    
    def get_reference(type, id)
      @references[type.to_s + id.to_s]
    end
    
    def [](idx)
      @objects[idx]
    end
  end
end