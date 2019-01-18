# frozen_string_literal: true

module Processor
  class SaintPaul
    URL = 'https://stpaul.legistar.com/'
    MAIN = 'Calendar.aspx'

    # requires nokogiri document
    def initialize(doc)
      @doc = doc
    end

    # requires nokogiri object
    def extract_details(row)
      {}.tap do |a|
        a[:name] = row.css('td').first.text.strip
        a[:date] = row.css('.rgSorted').text
        a[:details] = urlify(row.at('a:contains("details")'))
        a[:agenda] = urlify(row.at('a:contains("Agenda")'))
        a[:minutes] = urlify(row.at('a:contains("Minutes")'))
        a[:video] = urlify(row.at('a:contains("Video")'))
      end
    end

    # optional name of board/commission/committee/council/etc.
    def get_rows(name = nil)
      return @doc.css('.rgMasterTable tbody tr') unless name

      @doc.css('.rgMasterTable tbody tr').select do |r|
        r.css('td').first.text.strip == name
      end
    end

    private

    def urlify(row)
      return nil if row.nil?
      "#{URL}#{row.attributes['href'].text}"
    end
  end
end
