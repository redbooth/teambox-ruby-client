module Teambox
  class ResultSet
    attr_reader :first_id, :last_id
    
    def initialize(client, request, objects, references)
      @client = client
      @request = request
      @objects = objects.map { |o| Teambox.create_model(o['type'], o) }
      @references = {}.tap { |h| references.each {|ref| h[ref['type'].downcase + ref['id']] = Teambox.create_model(ref['type'], ref) } }
      
      id_list = objects.map{|obj| obj['id']}.sort
      @first_id = id_list[0]
      @last_id = id_list[-1]
    end
    
    def created_at
      @data.has_key?('created_at') ? Time.parse(data['created_at']) : nil
    end
    
    def updated_at
      @data.has_key?('updated_at') ? Time.parse(data['updated_at']) : nil
    end
  
    def each(&block)
      @objects.each do |object|
        yield object
      end
    end
  
    def empty?
      @objects.length == 0
    end
  
    # get previous items
    def prev
      @client.get(@request[:url], :query => (@request[:query]).merge(:before_id => @first_id))
    end
  
    # get next items
    def next
      @client.get(@request[:url], :query => (@request[:query]).merge(:since_id => @last_id))
    end
  
    def get_reference(type, id)
      @references[type.to_s.downcase + id]
    end
  end
end