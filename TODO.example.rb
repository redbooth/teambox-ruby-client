# This are methods that we didn't implement on Teambox, but sound like good ideas
# or reference methods

def friendship_destroy(id)
  perform_post("/friendships/destroy/#{id}.json")
end

def verify_credentials
  perform_get("/account/verify_credentials.json")
end

def users(*ids_or_usernames)
  ids, usernames = [], []
  ids_or_usernames.each do |id_or_username|
    if id_or_username.is_a?(Integer)
      ids << id_or_username
    elsif id_or_username.is_a?(String)
      usernames << id_or_username
    end
  end
  query = {}
  query[:user_id] = ids.join(",") unless ids.empty?
  query[:screen_name] = usernames.join(",") unless usernames.empty?
  perform_get("/users/lookup.json", :query => query)
end

def direct_message_destroy(id)
  perform_post("/direct_messages/destroy/#{id}.json")
end

# Options: id, user_id, screen_name
# Could be adapted to Teambox as "people in my projects"
def friend_ids(query={})
  perform_get("/friends/ids.json", :query => query)
end

# Options: in_reply_to_status_id
def update(status, query={})
  perform_post("/statuses/update.json", :body => {:status => status}.merge(query))
end

# Options: since_id, max_id, count, page
# options: count, page, ids_only
# Options: id, user_id, screen_name, page

# :per_page = max number of statues to get at once
# :page = which page of tweets you wish to get
def list_timeline(list_owner_username, slug, query = {})
  perform_get("/#{list_owner_username}/lists/#{slug}/statuses.json", :query => query)
end

def list_create(list_owner_username, options)
  perform_post("/#{list_owner_username}/lists.json", :body => {:user => list_owner_username}.merge(options))
end

def enable_notifications(id)
  perform_post("/notifications/follow/#{id}.json")
end

def disable_notifications(id)
  perform_post("/notifications/leave/#{id}.json")
end


def rate_limit_status
  perform_get("/account/rate_limit_status.json")
end

# One or more of the following must be present:
#   name, email, url, location, description
def update_profile(body={})
  perform_post("/account/update_profile.json", :body => body)
end










require 'pp'
module Teambox
  class Search
    include HTTParty
    include Enumerable
    base_uri "search.teambox.com/search"
    format :json

    attr_reader :result, :query

    def initialize(q=nil, options={})
      @options = options
      clear
      containing(q) if q && q.strip != ""
      endpoint_url = options[:api_endpoint]
      endpoint_url = "#{endpoint_url}/search" if endpoint_url && !endpoint_url.include?("/search")
      self.class.base_uri(endpoint_url) if endpoint_url
    end

    def user_agent
      @options[:user_agent] || "Ruby Teambox Gem"
    end

    def from(user, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}from:#{user}"
      self
    end

    def to(user, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}to:#{user}"
      self
    end

    def referencing(user, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}@#{user}"
      self
    end
    alias :references :referencing
    alias :ref :referencing

    def containing(word, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}#{word}"
      self
    end
    alias :contains :containing

    # adds filtering based on hash tag ie: #teambox
    def hashed(tag, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}\##{tag}"
      self
    end

    # Search for a phrase instead of a group of words
    def phrase(phrase)
      @query[:phrase] = phrase
      self
    end

    # lang must be ISO 639-1 code ie: en, fr, de, ja, etc.
    #
    # when I tried en it limited my results a lot and took
    # out several tweets that were english so i'd avoid
    # this unless you really want it
    def lang(lang)
      @query[:lang] = lang
      self
    end

    # popular|recent
    def result_type(result_type)
      @query[:result_type] = result_type
      self
    end

    # Limits the number of results per page
    def per_page(num)
      @query[:rpp] = num
      self
    end

    # Which page of results to fetch
    def page(num)
      @query[:page] = num
      self
    end

    # Only searches tweets since a given id.
    # Recommended to use this when possible.
    def since(since_id)
      @query[:since_id] = since_id
      self
    end

    # From the advanced search form, not documented in the API
    # Format YYYY-MM-DD
    def since_date(since_date)
      @query[:since] = since_date
      self
    end

    # From the advanced search form, not documented in the API
    # Format YYYY-MM-DD
    def until_date(until_date)
      @query[:until] = until_date
      self
    end

    # Ranges like 25km and 50mi work.
    def geocode(lat, long, range)
      @query[:geocode] = [lat, long, range].join(",")
      self
    end

    def max(id)
      @query[:max_id] = id
      self
    end

    # Clears all the query filters to make a new search
    def clear
      @fetch = nil
      @query = {}
      @query[:q] = []
      self
    end

    def fetch(force=false)
      if @fetch.nil? || force
        query = @query.dup
        query[:q] = query[:q].join(" ")
        perform_get(query)
      end

      @fetch
    end

    def each
      results = fetch()['results']
      return if results.nil?
      results.each {|r| yield r}
    end

    def next_page?
      !!fetch()["next_page"]
    end

    def fetch_next_page
      if next_page?
        s = Search.new(nil, :user_agent => user_agent)
        s.perform_get(fetch()["next_page"][1..-1])
        s
      end
    end

    protected

    def perform_get(query)
      response = self.class.get("#{self.class.base_uri}.json", :query => query, :format => :json, :headers => {"User-Agent" => user_agent})
      @fetch = Teambox.mash(response)
    end

  end
end

















module Teambox
  class OAuth
    extend Forwardable

    def_delegators :access_token, :get, :post, :put, :delete

    attr_reader :ctoken, :csecret, :consumer_options, :api_endpoint, :signing_endpoint

    # Options
    #   :sign_in => true to just sign in with teambox instead of doing oauth authorization
    #               (http://apiwiki.teambox.com/Sign-in-with-Teambox)
    def initialize(ctoken, csecret, options={})
      @ctoken, @csecret, @consumer_options = ctoken, csecret, {}
      @api_endpoint = options[:api_endpoint] || 'http://api.teambox.com'
      @signing_endpoint = options[:signing_endpoint] || 'http://api.teambox.com'
      if options[:sign_in]
        @consumer_options[:authorize_path] =  '/oauth/authenticate'
      end
    end

    def consumer
      @consumer ||= ::OAuth::Consumer.new(@ctoken, @csecret, {:site => api_endpoint}.merge(consumer_options))
    end
    
    def signing_consumer
      @signing_consumer ||= ::OAuth::Consumer.new(@ctoken, @csecret, {:site => signing_endpoint, :request_endpoint => api_endpoint }.merge(consumer_options))
    end

    def set_callback_url(url)
      clear_request_token
      request_token(:oauth_callback => url)
    end

    # Note: If using oauth with a web app, be sure to provide :oauth_callback.
    # Options:
    #   :oauth_callback => String, url that teambox should redirect to
    def request_token(options={})
      @request_token ||= signing_consumer.get_request_token(options)
    end

    # For web apps use params[:oauth_verifier], for desktop apps,
    # use the verifier is the pin that teambox gives users.
    def authorize_from_request(rtoken, rsecret, verifier_or_pin)
      request_token = ::OAuth::RequestToken.new(signing_consumer, rtoken, rsecret)
      access_token = request_token.get_access_token(:oauth_verifier => verifier_or_pin)
      @atoken, @asecret = access_token.token, access_token.secret
    end

    def access_token
      @access_token ||= ::OAuth::AccessToken.new(signing_consumer, @atoken, @asecret)
    end

    def authorize_from_access(atoken, asecret)
      @atoken, @asecret = atoken, asecret
    end

    private

    def clear_request_token
      @request_token = nil
    end

  end
end
