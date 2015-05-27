module Tmdb
  class Resource
    @@endpoints = {}
    @@endpoint_id = {}

    def initialize(attributes={})
      attributes.each do |key, value|
        if self.respond_to?(key.to_sym)
          self.instance_variable_set("@#{key}", value)
        end
      end
    end

    def self.has_resource(singular=nil, opts={})
      @@endpoints[self.name.downcase] = {
        :singular => singular.nil? ? "#{self.name.downcase}" : singular,
        :plural => opts[:plural].nil? ? "#{self.name.downcase}s" : opts[:plural]
      }
      @@endpoint_id[self.name.downcase] = opts[:id].nil? ? "" : "#{opts[:id]}-"
    end

    def self.endpoints
      @@endpoints[self.name.downcase]
    end

    def self.endpoint_id
      @@endpoint_id[self.name.downcase]
    end

    #Get the basic resource information for a specific id.
    def self.detail(id, conditions={})
      search = Tmdb::Search.new("/#{self.endpoints[:singular]}/#{self.endpoint_id + id.to_s}")
      search.filter(conditions)
      search.fetch_response
    end
    
    def self.detail_imdb_id(id, conditions={})
      search = Tmdb::Search.new("/#{self.endpoints[:singular]}/#{self.endpoint_id + id.to_s}")
      search.filter(conditions)
      search.fetch_response(external_source: 'imdb_id')
    end

    def self.list(conditions={})
      search = Tmdb::Search.new("/#{self.endpoints[:plural]}")
      search.filter(conditions)
      search.fetch.collect do |result|
        self.new(result)
      end
    end

    def self.search(query, conditions={})
      search = Tmdb::Search.new
      search.resource("#{self.endpoints[:singular]}")
      search.query(query)
      search.fetch(conditions).collect do |result|
        self.new(result)
      end
    end

    def self.find(query, conditions={})
      search = Tmdb::Search.new
      search.resource("#{self.endpoints[:singular]}")
      search.query(query)
      search.fetch(conditions).collect do |result|
        self.new(result)
      end
    end

    def self.myfind(query, conditions={})
        search = Tmdb::Search.new
        search.resource("find")
        search.query(query)
        search.fetch(conditions).collect do |result|
          self.new(result)
        end
    end

    def self.myfind_imdb_id(id, conditions={})
      search = Tmdb::Search.new("/find/#{self.endpoint_id + id.to_s}")
      search.filter(conditions)
      search.fetch_response(external_source: 'imdb_id')
    end

  end
end
