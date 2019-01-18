require 'test_helper'

class Processor::SaintPaulTest < ActiveSupport::TestCase
  setup do
    VCR.use_cassette('stp_legistar') do
      doc = Scraper.scrape('https://stpaul.legistar.com/Calendar.aspx')
      @p = Processor::SaintPaul.new doc
    end
  end

  test 'gets rows' do
    assert_equal 11, @p.get_rows.count
  end

  test 'filters rows' do
    rows = @p.get_rows 'City Council'
    assert_equal 4, rows.count
  end

  test 'extract row details' do
    rows = @p.get_rows 'City Council'
    d = @p.extract_details(rows.first)

    assert_equal 'City Council', d[:name]
    assert_equal '1/23/2019', d[:date]
    assert_equal 'MeetingDetail.aspx?ID=673702&GUID=175B19CE-A034-4C76-B59D-EB264420F691&Options=info&Search=', d[:details]
    assert_equal 'View.ashx?M=A&ID=673702&GUID=175B19CE-A034-4C76-B59D-EB264420F691', d[:agenda]
    assert_nil d[:minutes]
    assert_nil d[:video]
  end

end
