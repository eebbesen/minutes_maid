require 'test_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "vcr_cassettes"
  config.hook_into :webmock
end

class ScraperTest < ActiveSupport::TestCase
  test 'gets page content' do
    VCR.use_cassette('stp_legistar') do
      doc = Scraper.scrape('https://stpaul.legistar.com/Calendar.aspx')

      md = doc.at('.rgMasterTable a:contains("details")').text.strip

      assert_equal 'Meeting details', md
    end
  end

end