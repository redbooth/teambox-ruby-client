module Teambox
  class Base
    extend Forwardable

    def_delegators :client, :get, :post, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    # Teambox method
    def projects(query={})
      perform_get("/api/1/projects", :query => query)[:projects]
    end

    def activities(query={})
      perform_get("/api/1/activities", :query => query)[:activities]
    end

    def activities_from_project(project_id, query={})
      perform_get("/api/1/projects/#{project_id}/activities", :query => query)[:activities]
    end

    def people_from_project(project_id, query={})
      perform_get("/api/1/projects/#{project_id}/people", :query => query)[:people]
    end
    
    def comments_from_project(project_id, query={})
      perform_get("/api/1/projects/#{project_id}/comments", :query => query)[:comments]
    end

    # Not working, need to skip verify_authenticity_token on the server.
    def comment_on_project(project_id, body, query={})
      body = {:comment => {:body => body}, :project_id =>project_id}
      perform_post("/api/1/projects/#{project_id}/comments", :body => body, :query => {})[:comments]
    end

    def conversations_from_project(project_id, query={})
      perform_get("/api/1/projects/#{project_id}/conversations", :query => query)[:conversations]
    end

    def task_lists_from_project(project_id, query={})
      perform_get("/api/1/projects/#{project_id}/task_lists", :query => query)[:task_lists]
    end

    # Task list is not optional at the moment
    # def tasks_from_project(project_id, query={})
    #  perform_get("/api/1/projects/#{project_id}/tasks", :query => query)[:tasks]
    # end

    def user(username, query={})
      perform_get("/api/1/users/#{username}", :query => query)[:user]
    end

    
    protected

    def self.mime_type(file)
      case
        when file =~ /\.jpg/  then 'image/jpg'
        when file =~ /\.gif$/ then 'image/gif'
        when file =~ /\.png$/ then 'image/png'
        else 'application/octet-stream'
      end
    end

    def mime_type(f) self.class.mime_type(f) end

    CRLF = "\r\n"

    def self.build_multipart_bodies(parts)
      boundary = Time.now.to_i.to_s(16)
      body = ""
      parts.each do |key, value|
        esc_key = CGI.escape(key.to_s)
        body << "--#{boundary}#{CRLF}"
        if value.respond_to?(:read)
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"; filename=\"#{File.basename(value.path)}\"#{CRLF}"
          body << "Content-Type: #{mime_type(value.path)}#{CRLF*2}"
          body << value.read
        else
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"#{CRLF*2}#{value}"
        end
        body << CRLF
      end
      body << "--#{boundary}--#{CRLF*2}"
      {
        :body => body,
        :headers => {"Content-Type" => "multipart/form-data; boundary=#{boundary}"}
      }
    end

    def build_multipart_bodies(parts) self.class.build_multipart_bodies(parts) end

    private

    def perform_get(path, options={})
      Teambox::Request.get(self, path, options)
    end

    def perform_post(path, options={})
      Teambox::Request.post(self, path, options)
    end

    def perform_put(path, options={})
      Teambox::Request.put(self, path, options)
    end

    def perform_delete(path, options={})
      Teambox::Request.delete(self, path, options)
    end

  end
end
