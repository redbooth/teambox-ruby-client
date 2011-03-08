module Teambox
  class Client
    include HTTParty
    format :json

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
      api_unwrap(self.class.get(path, {:query => query}.merge(options)), {:url => path, :query => query}) #rescue nil
    end

    protected
    
    def api_unwrap(response, request={})
      if [200, 201, 202].include? response.response.code.to_i
        data = JSON.parse(response.body)
        raise StandardError.new('Please update your Teambox') unless response.has_key?('type')
        
        if response['type'] == 'List'
          ResultSet.new(self, request, data['objects'], data['references'])
        else
          Teambox.create_model(data['type'], data)
        end
      else
        raise ApiError.new(response.status, data['errors'])
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

  def self.create_model(type, data)
    klass = const_get(type.to_sym) rescue nil
    if klass
      klass.new data
    else
      throw UnknownResourceError.new(type)
    end
  end
  
  class Resource
    def initialize(data)
      @data = data
    end

    def id
      @data['id']
    end
    
    def next
      nil
    end
    
    def prev
      nil
    end

    def method_missing(method, *args, &block)
      @data.include?(method.to_s) ? @data[method.to_s] : super
    end
  end
end

Dir[File.expand_path('models/*.rb', File.dirname(__FILE__))].each { |f| require f }
