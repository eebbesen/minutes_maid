require 'nokogiri'
require 'open-uri'

module Scraper
  class << self
    def scrape(url)
      Nokogiri::HTML(open(url))
    end
  end
end