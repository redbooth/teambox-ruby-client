module Teambox
  # Methods used to authenticate with OAuth on teambox.com. Normally you won't have to call these.
  module OAuth
    attr_accessor :access_token
    
    # OAuth consumer required for authentication
    def consumer
      return nil if @auth[:oauth_app_id].nil?
      @consumer ||= OAuth2::Client.new(@auth[:oauth_app_id], @auth[:oauth_app_secret], :site => consumer_url, :authorize_path => consumer_url+'/oauth/authorize?response_type=code')
    end
    
    def consumer_url
      uri = URI.parse(self.class.base_uri)
      uri.path = '/'
      uri.to_s
    end
    
    # Generates a new request token
    def request_token(options={})
      @request_token ||= consumer.get_request_token(options)
    end
    
    # Is the client authorized via OAuth?
    def authorized?
      !@access_token.nil?
    end
    
    def authorize_from_request(verifier)
      @access_token = consumer.web_server.get_access_token(verifier, :redirect_url => @auth[:redirect_url])
      @auth[:oauth_token] = @access_token.token
      @auth[:oauth_secret] = @access_token.secret
      @access_token
    end
    
    # Authorizes the client from an existing OAuth token
    def authorize_from_access
      @access_token = ::OAuth2::AccessToken.new(nil, @auth[:oauth_token])
    end
  end
end