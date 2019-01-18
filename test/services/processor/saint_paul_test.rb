# frozen_string_literal: true

require 'test_helper'

class Processor::SaintPaulTest < ActiveSupport::TestCase
  setup do
    VCR.use_cassette('stp_legistar') do
      doc = Scraper.scrape("#{Processor::SaintPaul::URL}#{Processor::SaintPaul::MAIN}")
      @p = Processor::SaintPaul.new doc
    end
  end

  test 'gets meeting rows' do
    assert_equal 11, @p.get_meeting_rows.count
  end

  test 'filters meeting rows' do
    rows = @p.get_meeting_rows 'City Council'
    assert_equal 4, rows.count
  end

  test 'extract meeting details some nil' do
    rows = @p.get_meeting_rows 'City Council'
    d = Processor::SaintPaul.extract_meeting_details rows.first

    assert_equal 'City Council', d[:name]
    assert_equal '1/23/2019', d[:date]
    assert_equal "#{Processor::SaintPaul::URL}MeetingDetail.aspx?ID=673702&GUID=175B19CE-A034-4C76-B59D-EB264420F691&Options=info&Search=", d[:details]
    assert_equal "#{Processor::SaintPaul::URL}View.ashx?M=A&ID=673702&GUID=175B19CE-A034-4C76-B59D-EB264420F691", d[:agenda]
    assert_nil d[:minutes]
  end

  test 'extract meeting details none nil' do
    rows = @p.get_meeting_rows 'City Council'
    d = Processor::SaintPaul.extract_meeting_details rows[2]

    assert_equal 'City Council', d[:name]
    assert_equal '1/9/2019', d[:date]
    assert_equal "#{Processor::SaintPaul::URL}MeetingDetail.aspx?ID=670017&GUID=8FE16495-705F-4767-8C64-1A83376FB8F7&Options=info&Search=", d[:details]
    assert_equal "#{Processor::SaintPaul::URL}View.ashx?M=A&ID=670017&GUID=8FE16495-705F-4767-8C64-1A83376FB8F7", d[:agenda]
    assert_equal "#{Processor::SaintPaul::URL}View.ashx?M=M&ID=670017&GUID=8FE16495-705F-4767-8C64-1A83376FB8F7", d[:minutes]
  end

  test 'parse date string' do
    assert_equal Date.new(2019, 01, 30),
      Processor::SaintPaul.send(:parse_date, '1/30/2019')
  end

  test 'persist' do
    d = {
      name: 'City Council',
      date: '02/20/2019',
      details: 'https://www.example.com/test_deets',
      agenda: 'https://www.example.com/test_a',
      minutes: 'https://www.example.com/test_m',
    }
    Processor::SaintPaul.send(:persist, d)

    r = Meeting.last

    assert_equal d[:name], r.name
    assert_equal Date.new(2019, 02, 20), r.date
    assert_equal d[:details], r.details
    assert_equal d[:agenda], r.agenda
    assert_equal d[:minutes], r.minutes
  end
end
