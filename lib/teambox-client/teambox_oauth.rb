module Teambox
  module OAuth
    attr_accessor :access_token
    
    def consumer
      return nil if @auth[:oauth_app_id].nil?
      @consumer ||= OAuth2::Client.new(@auth[:oauth_app_id], @auth[:oauth_app_secret], :site => consumer_url, :authorize_path => consumer_url+'/oauth/authorize?response_type=code')
    end
    
    def consumer_url
      uri = URI.parse(self.class.base_uri)
      uri.path = '/'
      uri.to_s
    end
    
    def request_token(options={})
      @request_token ||= consumer.get_request_token(options)
    end
    
    def authorized?
      !@access_token.nil?
    end
    
    def authorize_from_request(verifier)
      @access_token = consumer.web_server.get_access_token(verifier, :redirect_url => @auth[:redirect_url])
      @auth[:oauth_token] = @access_token.token
      @auth[:oauth_secret] = @access_token.secret
      @access_token
    end
    
    def authorize_from_access
      @access_token = ::OAuth1::AccessToken.new(nil, @auth[:oauth_token])
    end
  end
end