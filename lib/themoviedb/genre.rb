module Tmdb
	class Genre
    def initialize(attributes={})
      attributes.each do |key, value|
        if self.respond_to?(key.to_sym)
          self.instance_variable_set("@#{key}", value)
        end
      end
    end

		#http://docs.themoviedb.apiary.io/#genres
		@@fields = [
			:id,
			:page,
			:total_pages,
			:total_results,
			:results
		]

		@@fields.each do |field|
			attr_accessor field
		end

		def self.search(query)
			self.detail(self.list['genres'].detect { |g| g['name'] == query }['id'])
		end

		class << self
			alias_method :find, :search
		end

		def self.list(conditions={})
			search = Tmdb::Search.new("/genre/list")
			search.fetch_response(conditions)
		end

		def self.detail(id, params={}, conditions={})
			url = "/genre/#{id}/movies"
			if !params.empty?
				url << "?"
				params.each_with_index do |(key, value), index|
					url << "#{key}=#{value}"
					if index != params.length - 1
						url << "&"
					end
				end
			end
			search = Tmdb::Search.new(url)
			self.new(search.fetch_response(conditions))
		end

		def name
			@name ||= self.class.list['genres'].detect { |g| g['id'] == @id }['name']
		end

		def get_page(page_number, conditions={})
			if page_number != @page and page_number > 0 and page_number <= @total_pages
				conditions.merge!({ :page => page_number })
				self.class.detail(id, conditions)
			end
		end
	end
end