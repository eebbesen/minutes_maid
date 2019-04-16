# frozen_string_literal: true

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'computes rlh hclass' do
    i = items(:item_one)
    assert_equal 'rlh', i.hclass
  end

  test 'computes res hclass' do
    i = items(:item_one)
    i.item_type = 'Resolution'
    assert_equal 'res', i.hclass
  end

  test 'computes gen hclass' do
    i = items(:item_one)
    i.item_type = 'Ordinance'
    assert_equal 'ordinance', i.hclass
  end

  test 'note count user-specific' do
    i = items(:item_one)
    u1 = users(:user_one)
    u2 = users(:user_two)

    assert_equal 2, i.user_notes(u1.id).count
    assert_equal 0, i.user_notes(u2.id).count
  end
end
