# frozen_string_literal: true

require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
  test 'gets city hclass' do
    m = meetings(:one)
    assert_equal 'city', m.hclass
  end

  test 'gets organizational hclass' do
    m = meetings(:three)
    assert_equal 'organizational', m.hclass
  end

  test 'gets board of water commission hclass' do
    m = meetings(:four)
    assert_equal 'water', m.hclass
  end

  test 'gets hclass when no name' do
    m = meetings(:four)
    m.name = nil
    assert_equal '', m.hclass
  end
end
