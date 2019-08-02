# frozen_string_literal: true

require 'application_system_test_case'

class AboutTest < ApplicationSystemTestCase
  test 'menu bar when logged in' do
    sign_in users(:user_one)
    visit static_pages_about_url
    assert_selector '.top-bar-right', text: 'kim.smith@example.com | Sign out'
  end

  test 'menu bar when logged out' do
    visit static_pages_about_url
    assert_selector '.top-bar-right', text: 'Login'
  end
end
