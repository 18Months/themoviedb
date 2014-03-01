module Tmdb
  class Search
    AVAILABLE_RESOURCES = %w{movie collection tv person list company keyword}

    def initialize(resource=nil)
      @params = {}
      @resource = resource.nil? ? '/search/movie' : resource
      self
    end

    def query(query)
      @params[:query] = "#{query}"
      self
    end

    def year(year)
      @params[:year] = "#{year}"
      self
    end

    def primary_realease_year(year)
      @params[:primary_release_year] = "#{year}"
      self
    end

    def resource(resource)
      if AVAILABLE_RESOURCES.include?(resource) then
        @resource = "/search/#{resource}"
      elsif resource == 'find'
        @resource = '/find'
      else
        raise Tmdb::Error, "The requested resource is not available."
      end

      self
    end

    def filter(conditions)
      if conditions
        conditions.each do |key, value|
          if self.respond_to?(key)
            self.send(key, value)
          else
            @params[key] = value
          end
        end
      end
    end

    #Sends back main data
    def fetch()
      fetch_response['results']
    end

    #Send back whole response
    def fetch_response(conditions={})
      if conditions[:external_source]
        options = @params.merge(Api.config.merge({external_source: conditions[:external_source]}))
      else
        options = @params.merge(Api.config)
      end
      response = Api.get(@resource, :query => options)

      if has_errors?(response)
        raise Tmdb::Error, response.fetch('status_message', 'An unknown error occurred')
      end

      original_etag = response.headers.fetch('etag', '')
      etag = original_etag.gsub(/"/, '')

      Api.set_response({'code' => response.code, 'etag' => etag})
      response.to_hash
    end

    private
      def has_errors?(response)
        # status_code possibilities
        #   6:  Invalid id
        #   7:  Invalid API key
        #   10: API key suspended, not good
        #   12: The item/record was updated successfully
        #   17: Session denied
        if response.code != 200
          case response.fetch('status_code', -1)
          when is_item_id_invalid?
            return true
          when is_api_key_invalid?
            return true
          when is_api_key_suspended?
            return true
          when is_session_denied?
            return true
          when is_update_successful?
            return false
          default
            return true
          end
        end

        return false
      end

      def is_item_id_invalid?
        ->(status_code) { status_code == 6 }
      end

      def is_api_key_invalid?
        ->(status_code) { status_code == 7 }
      end

      def is_api_key_suspended?
        ->(status_code) { status_code == 10 }
      end

      def is_update_successful?
        ->(status_code) { status_code == 12 }
      end

      def is_session_denied?
        ->(status_code) { status_code == 17 }
      end
  end
end
