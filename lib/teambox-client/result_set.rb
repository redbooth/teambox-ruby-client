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
    include ReferenceList
    attr_reader :first_id, :last_id, :client, :references, :objects
    
    def initialize(client, request, objects, references) #:nodoc:
      @client = client
      @request = request
      generate_references(references)
      @objects = objects.map { |o| Teambox.create_model(o['type'], o, self) }
      
      id_list = objects.map{|obj| obj['id']}.sort
      @first_id = id_list[0]
      @last_id = id_list[-1]
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