module Tmdb
  class Configuration < Resource
    attr_reader :config

    def initialize
      @params = {}
      @query_url = '/configuration'
    end

    def conf
      @config ||= get_configuration
    end

    def update_configuration
      @config = get_configuration
    end

    private
      def get_configuration
        self.run
      end
  end
end