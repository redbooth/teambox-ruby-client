module Teambox
  # This represents a list of objects along with referenced objects returned by the API.
  #
  # == Basic Usage
  #
  # A Teambox::ResultSet is usually returned from a get request from Teambox::Client. e.g.:
  #
  #   list = client.get('/projects') # Teambox::ResultSet
  #   puts "Returned #{list.length} projects"
  #
  # The Teambox API only returns a limited amount of objects per request (currently 50), 
  # so the methods prev, next, and empty? are provided to navigate the list of objects. 
  # e.g. To get all projects, you can use something like:
  #
  #   project_list = []
  #   list = client.get('/projects')
  #   while !list.empty?
  #     items += list.objects
  #     list = list.prev
  #   end
  #
  class ResultSet
    attr_reader :first_id, :last_id, :client, :references, :objects
    
    def initialize(client, request, objects, references) #:nodoc:
      @client = client
      @request = request
      @objects = objects.map { |o| Teambox.create_model(o['type'], o, self) }
      @references = {}.tap { |h| references.each {|ref| h[ref['type'] + ref['id'].to_s] = Teambox.create_model(ref['type'], ref, self) } }
      
      id_list = objects.map{|obj| obj['id']}.sort
      @first_id = id_list[0]
      @last_id = id_list[-1]
    end
    
    # References resource in the current Teambox::ResultSet
    def set_reference(klass, resource)
      real_resource = if resource.is_a? Teambox::Resource
        resource
      else
        Teambox.const_get(klass).new(resource, self)
      end
      
      @references[klass.to_s + real_resource.id.to_s] = real_resource
      real_resource
    end
    
    # Array variant of set_reference
    def set_references(klass, list)
      list.each { |o| set_reference(klass, o) }
    end
    
    # Gets a referenced object. e.g:
    #   get_reference('User', 1)
    def get_reference(klass, id)
      @references[klass.to_s + id.to_s]
    end
    
    # Array variant of get_reference, e.g:
    #   get_references('User', [1])
    def get_references(klass, ids)
      classname = klass.to_s
      ids.map{ |id| @references[classname + id.to_s] }.compact
    end
    
    # Yields for each object
    def each(&block)
      @objects.each(&block)
    end
    
    # Yields for each object
    def map(&block)
      @objects.map(&block)
    end
    
    # Length of object list
    def length
      @objects.length
    end
    
    # Is the object list empty?
    def empty?
      @objects.length == 0
    end
    
    # Gets older items as a Teambox::ResultSet
    def prev
      @client.get(@request[:url], {}, :query => (@request[:query]).merge(:max_id => @first_id))
    end
    
    # Gets newer items as a Teambox::ResultSet
    def next
      @client.get(@request[:url], {}, :query => (@request[:query]).merge(:since_id => @last_id))
    end
    
    # Indexes into object array
    def [](idx)
      @objects[idx]
    end
  end
end