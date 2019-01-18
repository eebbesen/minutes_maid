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
    def self.extract_meeting_data(row)
      {}.tap do |a|
        a[:name] = row.css('td').first.text.strip
        a[:date] = row.css('.rgSorted').text
        a[:details] = urlify(row.at('a:contains("details")'))
        a[:agenda] = urlify(row.at('a:contains("Agenda")'))
        a[:minutes] = urlify(row.at('a:contains("Minutes")'))
      end
    end

    # requires nokogiri object
    def self.extract_meeting_detail_data(row)
      tds = row.css('td')
      {}.tap do |a|
        a[:file_number] = tds.first.text.strip
        a[:version] = tds[1].text.strip
        a[:name] = tds[3].text.strip
        a[:type] = tds[4].text.strip
        a[:title] = tds[5].text.strip
        a[:action] = tds[6].text.strip.chomp
        a[:result] = tds[7].text.strip.chomp
      end
    end

    # optional name of board/commission/committee/council/etc.
    # corresponds to Name column in UI
    def get_meeting_rows(name = nil)
      return @doc.css('.rgMasterTable tbody tr') unless name

      @doc.css('.rgMasterTable tbody tr').select do |r|
        r.css('td').first.text.strip == name
      end
    end

    # meeting details
    # optional type is regex, so can be partial
    def self.get_meeting_detail_rows(url, type = nil)
      doc = Scraper.scrape(url)
      # page has two tabs (Meeting Items and Public Comments)
      # just get first
      rows = doc.css('.rgMasterTable tbody').first.css('tr')
      if type
        rows = rows.select do |r|
          type.match(r.css('td')[4].text.strip)
        end
      end
      rows
    end

    private_class_method def self.persist(data)
      d = data.clone
      d[:date] = parse_date(d[:date])
      Meeting.new(d).save!
    end

    private_class_method def self.parse_date(date)
      m, d, y = date.split('/').map(&:to_i)
      Date.new(y, m, d)
    end

    private_class_method def self.urlify(row)
      return nil if row.nil?

      "#{URL}#{row.attributes['href'].text}"
    end
  end
end
