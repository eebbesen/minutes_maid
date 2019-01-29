# frozen_string_literal: true

require 'application_system_test_case'

class ItemsTest < ApplicationSystemTestCase
  setup do
    @item = items(:one)
  end

  test 'visiting the index' do
    visit items_url
    assert_selector 'h1', text: 'Items'
  end
end
