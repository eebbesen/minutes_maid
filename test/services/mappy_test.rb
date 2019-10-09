# frozen_string_literal: true

require 'test_helper'
require 'mocha/minitest'

class MappyTest < ActiveSupport::TestCase
  test 'gets page content' do
    VCR.use_cassette('google_maps_mac') do
      l = Mappy.link('1600 Grand Ave')

      assert_equal 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=ChIJZW__ehcq9ocRYN-4nWCtgX4', l
    end
  end

  test 'returns empty string when no result' do
    l = Mappy.link('')

    assert_equal '', l

  end

  test 'does not blow up when the google places api returns request denied' do
    VCR.use_cassette('google_maps_mac') do
      Google::Maps
          .expects(:places)
          .raises(Google::Maps::InvalidResponseException, 'Google returned an error status: REQUEST_DENIED')

      l = Mappy.link('1600 Grand Ave')

      assert_equal '', l
    end
  end
end
