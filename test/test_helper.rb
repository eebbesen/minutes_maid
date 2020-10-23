# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'app/channels/application_cable/channel.rb'
  add_filter 'app/channels/application_cable/connection.rb'
  add_filter 'app/controllers/registrations_controller.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/models/ahoy'
  add_filter 'app/models/application_record.rb'
  add_filter 'app/models/user.rb' # devise
  add_filter 'vendor'
end

# Webdrivers::Chromedriver.update # this will auto-update chromedriver version

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'vcr'

VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = 'vcr_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = { erb: true }
end

ENV['MM_GOOGLE_API_KEY'] = 'ABCDEF'
Google::Maps.configure do |config|
  config.authentication_mode = Google::Maps::Configuration::API_KEY
  config.api_key = ENV['MM_GOOGLE_API_KEY']
end

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
