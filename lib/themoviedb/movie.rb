module Tmdb
  class Movie < Struct

    def self.detail(id, filters={})
      result = Resource.new("/movie/#{id}", filters).run
      self.new(result)
    end

    def self.alternative_titles(id, filters={})
      result = Resource.new("/movie/#{id}/alternative_titles", filters).run

      result['titles'].map do |title|
        self.new(title)
      end
    end

  end
end