require 'ostruct'
require 'httparty'
require 'active_support/all'

require 'themoviedb/api'
require 'themoviedb/error'
require 'themoviedb/struct'
require 'themoviedb/utils'

require 'themoviedb/resource'

require 'themoviedb/account'
require 'themoviedb/configuration'
require 'themoviedb/authentication'
require 'themoviedb/certification'
require 'themoviedb/changes'
require 'themoviedb/collection'
require 'themoviedb/company'
require 'themoviedb/credit'
require 'themoviedb/discover'
require 'themoviedb/find'
require 'themoviedb/genre'
require 'themoviedb/job'
require 'themoviedb/keyword'
require 'themoviedb/list'
require 'themoviedb/movie'
require 'themoviedb/network'
require 'themoviedb/person'
require 'themoviedb/review'
require 'themoviedb/search'
require 'themoviedb/tv'
require 'themoviedb/tv/season'
require 'themoviedb/tv/episode'

require 'themoviedb/version'

class Hash
  def to_tmdb_struct(klass=Tmdb::Struct)
    if descendent_of_tmdb_struct?(klass)
      klass.new(self)
    else
      raise Tmdb::Error, 'Tried to convert to a non Tmdb::Struct object'
    end
  end

  private
  def descendent_of_tmdb_struct?(klass)
    klass.ancestors.include?(Tmdb::Struct)
  end
end
