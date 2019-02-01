# frozen_string_literal: true

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'computes rlh hclass' do
    i = items(:one)
    assert_equal 'rlh', i.hclass
  end

  test 'computes res hclass' do
    i = items(:one)
    i.item_type = 'Resolution'
    assert_equal 'res', i.hclass
  end

  test 'computes gen hclass' do
    i = items(:one)
    i.item_type = 'Ordinance'
    assert_equal 'ordinance', i.hclass
  end
end
