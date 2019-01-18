# frozen_string_literal: true

require 'test_helper'

class ScraperTest < ActiveSupport::TestCase
  test 'gets page content' do
    VCR.use_cassette('stp_legistar') do
      doc = Scraper.scrape('https://stpaul.legistar.com/Calendar.aspx')

      md = doc.at('.rgMasterTable a:contains("details")').text.strip
      rows = doc.css('.rgMasterTable tbody tr')

      assert_equal 'Meeting details', md
      assert_equal 11, rows.count
    end
  end
end
