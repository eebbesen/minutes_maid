# frozen_string_literal: true

desc 'scrape records for Saint Paul'
task scrape_saint_paul: :environment do
  p = Processor::SaintPaul.new
  p.process

  Processor::SaintPaul.add_geo_links
end
