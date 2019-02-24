# frozen_string_literal: true

require 'test_helper'

class MappyTest < ActiveSupport::TestCase
  test 'gets page content' do
    VCR.use_cassette('google_maps_mac') do
      l = Mappy.link('1600 Grand Ave')

      assert_equal 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=ChIJZW__ehcq9ocRYN-4nWCtgX4', l
    end
  end

  test 'returns empty string when no result' do
    VCR.use_cassette('google_maps_nw') do
      l = Mappy.link('')

      assert_equal '', l
    end
  end
end
