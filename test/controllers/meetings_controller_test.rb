# frozen_string_literal: true

require 'test_helper'

class MeetingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meeting = meetings(:one)
  end

  test 'should get index' do
    get meetings_url
    assert_response :success
  end

  test 'should show meeting' do
    get meeting_url(@meeting)
    assert_response :success
  end
end
