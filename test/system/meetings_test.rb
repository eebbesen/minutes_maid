# frozen_string_literal: true

require 'application_system_test_case'

class MeetingsTest < ApplicationSystemTestCase
  setup do
    @meeting = meetings(:one)
  end

  test 'visiting the index' do
    visit meetings_url
    assert_selector 'h1', text: 'Meetings'
  end
end
