
module Teambox
  # This is the entrypoint to the Teambox API.
  class Client
    include HTTParty
    include Teambox::OAuth
    
    # Initializes the Teambox client
    def initialize(opts = {})
      opts[:base_uri] ||= 'https://teambox.com/api/1'
      self.class.base_uri(opts[:base_uri])
      
      @base_uri = opts[:base_uri]
      @auth = {}
      authenticate(opts[:auth]) if opts[:auth]
      @consumer = consumer if oauth?
    end
    
    # Returns true if oauth is being used for authentication
    def oauth?
      !@auth[:oauth_app_id].nil?
    end
    
    # Returns the URL required to authenticate access if using OAuth
    def authorize_url(opts={})
      if oauth?
        @consumer.web_server.authorize_url({:redirect_url => @auth[:redirect_url]}.merge(opts))
      else
        nil
      end
    end
    
    # Authenticates the client with teambox
    def authenticate(opts={})
      @current_user = nil
      if oauth?
        if opts[:oauth_verifier]
          authorize_from_request(opts[:oauth_verifier])
        elsif opts[:oauth_token]
          @auth.merge!({:oauth_token => opts[:oauth_token], :oauth_secret => opts[:oauth_secret]})
          authorize_from_access
        end
      else
        if opts[:user]
          @auth.merge!({:user => opts[:user], :password => opts[:password]})
          self.class.basic_auth(@auth[:user], @auth[:password])
        end
      end
      
      !current_user.nil?
    end

    # Is the client is authenticated?
    def authenticated?
      !current_user.nil?
    end

    # Current user the client is logged in as
    def current_user
      @current_user ||= safe_get('/account')
    end

    # Performs a GET on path
    def get(path, query={}, options={})
      api_unwrap perform_request(:get, path, {:query => query}.merge(options)), {:url => path, :query => query}
    end

    # Performs a POST on path
    def post(path, query={}, options={})
      api_unwrap perform_request(:post, path, {:body => query}.merge(options)), {:url => path, :body => query}
    end

    # Performs a PUT on path
    def put(path, query={}, options={})
      api_unwrap perform_request(:put, path, {:body => query}.merge(options)), {:url => path, :body => query}
    end

    # Performs a DELETE on path
    def delete(path, query={}, options={})
      api_unwrap perform_request(:delete, path, {:body => query}.merge(options)), {:url => path, :body => query}
    end
    
    # Performs a GET on path, catching any exceptions
    def safe_get(path, query={}, options={})
      api_unwrap(perform_request(:get, path, {:query => query}.merge(options)), {:url => path, :query => query}) rescue nil
    end
    
    # urls
    
    # Gets a list Teambox::Project corresponding to the current users project list
    def projects(query={})
      get('/projects', query)
    end
    
    # Gets a Teambox::Project by id or permalink
    def project(id)
      get("/projects/#{id}")
    end

    protected
    
    # Internal request handler
    def perform_request(method, path, options)
      options[:headers] ||= {}
      headers = options[:headers]
      
      options[:query][:access_token] = @access_token.token if @access_token
      self.class.send(method, path, options)
    end
    
    # Decodes response and returns appropriate API object
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

  def self.create_model(type, data, list=nil) #:nodoc:
    klass = const_get(type.to_sym) rescue nil
    if klass
      klass.new data, list
    else
      throw UnknownResourceError.new(type)
    end
  end
  
  # Represents an object located on Teambox
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
    
    def next #:nodoc:
      nil
    end
    
    def prev #:nodoc:
      nil
    end
    
    # Location of this object on teambox, used for updating
    def url
      nil
    end
    
    # Reloads the resource from source data
    def reload
      if @list.client && url
        updated = @list.client.get(url) rescue nil
        unless updated.nil?
          @data = updated.data
        end
      end
      self
    end
    
    # Saves the resource to teambox
    def save
      if @list.client && url
        updated = @list.client.put(url, @data) rescue nil
        return true unless updated.nil?
      end
      false
    end
    
    # Destroys the resource on teambox
    def destroy
      @list.client.delete(url) if @list.client && url
      true
    end
    
    # Sets reference in resource list. e.g.
    #   set_reference('User', user)
    def set_reference(klass, resource)
      @list ? @list.set_reference(klass, resource) : resource.id
    end
    
    # get reference based on data. Makes new resource if reference does not exist. e.g.
    #   get_reference('User', @data, 'user_id', 'user')
    def get_reference(klass, data, field_id, field_data=nil)
      if @list
        @list.get_reference(klass, data[field_id]) || 
        @list.set_reference(klass, (data[field_data]||{}).merge({'id' => data[field_id]}))
      else
        nil
      end
    end
    
    # get a list of references based on data. Makes a new resource for each references which doesnot exist.
    def get_references(klass, data, field_id, field_data=nil)
      ret = nil
      if @list
        ret = if data[field_data]
          data[field_data].map do |object|
            @list.get_reference(klass, object['id']) ||
            @list.set_reference(klass, object)
          end
        elsif data[field_id]
          data[field_id].map do |object_id|
            @list.get_reference(klass, object_id) ||
            @list.set_reference(klass, {'id' => object_id})
          end
        else
          nil
        end
      end
      
      ret || []
    end
    
    def method_missing(method, *args, &block) #:nodoc:
      @data.include?(method.to_s) ? @data[method.to_s] : super
    end
  end
end

Dir[File.expand_path('models/*.rb', File.dirname(__FILE__))].each { |f| require f }
