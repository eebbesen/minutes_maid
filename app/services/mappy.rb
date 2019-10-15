# frozen_string_literal: true

require 'google-maps'

# Google Maps helper
module Mappy
  URL = 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id='
  POST = ' Saint Paul, MN'
  class << self
    def link(place)
      places = []
      return '' if place.blank?
      return '' if Google::Maps.api_key.blank?

      begin
        places = Google::Maps.places(place + POST)
      rescue Google::Maps::ZeroResultsException, Google::Maps::InvalidResponseException => e
        puts "Exception in Mappy#link for #{place}: #{e.message}"
        return ''
      end
      return '' unless places.size.positive?

      "#{URL}#{places.first.place_id}"
    end
  end
end
