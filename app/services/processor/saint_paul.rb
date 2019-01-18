# frozen_string_literal: true

module Processor
  class SaintPaul
    # requires nokogiri document
    def initialize(doc)
      @doc = doc
    end

    # requires nokogiri object
    def extract_details(row)
      {}.tap do |a|
        a[:name] = row.css('td').first.text.strip
        a[:date] = row.css('.rgSorted').text
        a[:details] = row.at('a:contains("details")').attributes['href'].text
        a[:agenda] = row.at('a:contains("Agenda")').attributes['href'].text
        min = row.at('a:contains("Minutes")')
        a[:minutes] = min ? row.at('a:contains("Minutes")').attributes['href'].text : nil
        vid = row.at('a:contains("Video")')
        a[:minutes] = vid ? row.at('a:contains("Video")').attributes['href'].text : nil
      end
    end

    # optional name of board/commission/committee/council/etc.
    def get_rows(name = nil)
      return @doc.css('.rgMasterTable tbody tr') unless name

      @doc.css('.rgMasterTable tbody tr').select do |r|
        r.css('td').first.text.strip == name
      end
    end
  end
end
