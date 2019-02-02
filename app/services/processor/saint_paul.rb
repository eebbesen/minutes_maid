# frozen_string_literal: true

module Processor
  class SaintPaul
    URL = 'https://stpaul.legistar.com/'
    MAIN = 'Calendar.aspx'

    # requires nokogiri document
    def initialize
      @doc = Processor::SaintPaul.scrape_meetings
    end

    def process
      get_meeting_rows.each do |m|
        md = Processor::SaintPaul.extract_meeting_data(m)
        meeting = Processor::SaintPaul.send(:persist_meeting, md)
        r = Processor::SaintPaul.get_meeting_detail_rows meeting[:details]
        r.each do |d|
          i = Processor::SaintPaul.extract_meeting_detail_data(d).merge(meeting_id: meeting.id)
          Processor::SaintPaul.send(:persist_item, i)
        end
      end
    end

    def self.scrape_meetings
      doc = Scraper.scrape "#{URL}#{MAIN}"
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
        unless tds.first.text == 'No records to display.'
          a[:file_number] = tds.first.text.strip
          a[:link] = "#{URL}#{tds.children.first.elements.first.attributes['href'].text.strip}"
          a[:version] = tds[1].text.strip
          a[:name] = tds[3].text.strip
          a[:item_type] = tds[4].text.strip
          a[:title] = tds[5].text.strip
          a[:action] = tds[6].text.strip
          a[:result] = tds[7].text.strip
        end
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
    # optional iteM_type is regex, so can be partial
    def self.get_meeting_detail_rows(url, item_type = nil)
      row_data = Scraper.scrape(url)
      # page has two tabs (Meeting Items and Public Comments)
      # just get first
      rows = row_data.css('.rgMasterTable tbody').first.css('tr')
      if item_type
        rows = rows.select do |r|
          item_type.match(r.css('td')[4].text.strip)
        end
      end
      rows
    end

    private_class_method def self.persist_meeting(data)
      d = data.clone
      d[:date] = parse_date(d[:date])

      Meeting.where(name: d[:name], date: d[:date]).first_or_create!(d).tap do |m|
        m.assign_attributes d
        m.save! if m.changed?
      end
    end

    private_class_method def self.persist_item(data)
      d = data.clone
      Item.where(meeting_id: d[:meeting_id], name: d[:name]).first_or_create!(d).tap do |i|
        i.assign_attributes d
        i.save! if i.changed?
      end
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
