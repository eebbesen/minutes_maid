# frozen_string_literal: true

require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
  end

  test 'should get index' do
    get items_url
    assert_response :success
  end

  test 'should show item' do
    get item_url(@item)
    assert_response :success
  end
end
