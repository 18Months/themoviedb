module Tmdb
  class Search
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
      @resource = case resource
      when 'movie'
        '/search/movie'
      when 'collection'
        '/search/collection'
      when 'tv'
        '/search/tv'
      when 'person'
        '/search/person'
      when 'list'
        '/search/list'
      when 'company'
        '/search/company'
      when 'keyword'
        '/search/keyword'
      when 'find'
        '/find'
      when 'myfind'  
        '/find'        
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
    def fetch(conditions={})
      fetch_response(conditions).results
    end

    #Send back whole response
    def fetch_response(conditions={})
      if conditions
        options = @params.merge(Api.config.merge(conditions))
      else
        options = @params.merge(Api.config)
      end
      response = Api.get(@resource, :query => options)

      original_etag = response.headers.fetch('etag', '')
      etag = original_etag.gsub(/"/, '')

      Api.set_response({'code' => response.code, 'etag' => etag})
      return response.to_hash.to_hashugar
    end

  end
end
