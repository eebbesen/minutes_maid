require 'google-maps'

module Mappy
  URL = 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id='.freeze
  class << self
    def link(p)
      return '' if p.blank?
      places = Google::Maps.places(p)
      return '' unless places.size.positive?
      "#{URL}#{places.first.place_id}"
    end
  end
end
