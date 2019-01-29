# frozen_string_literal: true

# require './app/models/meeting'
# require './app/services/processor/saint_paul'
# require './app/services/scraper'

desc 'scrape records for Saint Paul'
task scrape_saint_paul: :environment do
  # require 'app/services/processor/saint_paul'
  # require File.join(Rails.root, 'app', 'services', 'processor', 'saint_paul.rb')
  # require File.join(Rails.root, 'app', 'services', 'scraper.rb')

  p = Processor::SaintPaul.new
  p.process
end
