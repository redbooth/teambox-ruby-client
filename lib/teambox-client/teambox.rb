module Teambox
  class Client
    include HTTParty

    def initialize(opts = {})
      opts[:base_uri] ||= 'https://teambox.com/api/1'
      self.class.base_uri(opts[:base_uri])
      self.class.basic_auth(opts[:auth][:user], opts[:auth][:password]) if opts[:auth]
      
      @auth = opts[:auth]
      @current_user = nil
    end
    
    def authenticate
      current_user
    end

    def authenticated?
      !current_user.nil?
    end

    def current_user
      @current_user ||= safe_get('/account')
    end

    def get(path, query={}, options={})
      api_unwrap self.class.get(path, {:query => query}.merge(options)), {:url => path, :query => query}
    end

    def post(path, query={}, options={})
      api_unwrap self.class.post(path, {:body => query}.merge(options)), {:url => path, :body => query}
    end

    def put(path, query={}, options={})
      api_unwrap self.class.put(path, {:body => query}.merge(options)), {:url => path, :body => query}
    end

    def delete(path, query={}, options={})
      api_unwrap self.class.delete(path, {:body => query}.merge(options)), {:url => path, :body => query}
    end
    
    def safe_get(path, query={}, options={})
      api_unwrap(self.class.get(path, {:query => query}.merge(options)), {:url => path, :query => query}) rescue nil
    end
    
    # urls
    
    def projects(query={})
      get('/projects', query)
    end
    
    def project(id)
      get("/projects/#{id}")
    end

    protected
    
    def api_unwrap(response, request={})
      data = JSON.parse(response.body) rescue nil
      if [200, 201, 202].include? response.response.code.to_i
        raise StandardError.new('Please update your Teambox') unless response.has_key?('type')
        if data['type'] == 'List'
          ResultSet.new(self, request, data['objects'], data['references'])
        else
          Teambox.create_model(data['type'], data, ResultSet.new(self, request, [], []))
        end
      else
        error_list = data ? data['errors'] : {'type' => 'UnknownError', 'message' => data}
        raise APIError.new(response.response.code, error_list)
      end
    end

  end

  class APIError < StandardError
    attr_reader :error_type, :status_code
    def initialize(status_code, details)
      @error_type = details['type'].to_sym
      @status_code = status_code
      super(details['message'] || details['type'])
    end
  end
  
  class UnknownResourceError < APIError
    def initialize(type)
      super(200, {'type' => 'UnknownResource', :message => "Unknown Resource #{type}"})
    end
  end

  def self.create_model(type, data, list=nil)
    klass = const_get(type.to_sym) rescue nil
    if klass
      klass.new data, list
    else
      throw UnknownResourceError.new(type)
    end
  end
  
  class Resource
    attr_accessor :list, :data
    
    def initialize(data, result_list=nil)
      @data = data
      @list = result_list || ResultSet.new(nil, nil, [], [])
    end

    def id
      @data['id']
    end
    
    def created_at
      @data.has_key?('created_at') ? Time.parse(data['created_at']) : nil
    end
    
    def updated_at
      @data.has_key?('updated_at') ? Time.parse(data['updated_at']) : nil
    end
    
    def next
      nil
    end
    
    def prev
      nil
    end
    
    def url
      nil
    end
    
    # reload from source data
    def reload
      if @list.client && url
        updated = @list.client.get(url) rescue nil
        unless updated.nil?
          @data = updated.data
        end
      end
      self
    end
    
    def save
      if @list.client && url
        updated = @list.client.put(url, @data) rescue nil
        return true unless updated.nil?
      end
      false
    end
    
    def destroy
      @list.client.delete(url) if @list.client && url
      true
    end
    
    # Sets reference in resource list. e.g.
    #   set_reference('User', user)
    def set_reference(klass, resource)
      @list ? @list.set_reference(klass, resource) : resource.id
    end
    
    # get reference based on data. makes new resource if reference does not exist. e.g.
    #   get_reference('User', @data, 'user_id', 'user')
    def get_reference(klass, data, field_id, field_data={})
      if @list
        @list.get_reference(klass, data[field_id]) || 
        @list.set_reference(klass, (data[field_data]||{}).merge({'id' => data[field_id]}))
      else
        nil
      end
    end
    
    def method_missing(method, *args, &block)
      @data.include?(method.to_s) ? @data[method.to_s] : super
    end
  end
end

Dir[File.expand_path('models/*.rb', File.dirname(__FILE__))].each { |f| require f }
