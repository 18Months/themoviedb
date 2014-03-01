require 'rspec'
require 'spec_helper'
require 'vcr'

describe Tmdb::Search do
  before(:each) do
    Tmdb::Api.key("8a221fc31fcdf12a8af827465574ffc9")
  end

  describe "#fetch_response" do

    it "should raise an error if the API key is wrong" do
      VCR.use_cassette  'search/api_key_wrong' do
        Tmdb::Api.key('1234567890')

        expect { @search.fetch_response }.to raise_error(Tmdb::Error)
      end
    end

    it "should raise an error if ID is non-existent" do
      VCR.use_cassette  'search/id_non_existent' do
        expect { Tmdb::Movie.detail(1) }.to raise_error(Tmdb::Error)
      end
    end

  end

end