# frozen_string_literal: true

require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
  end

  test 'should get index' do
    VCR.use_cassette('google_maps_marshall_two') do
      get items_url

      assert_response :success
      assert response.body.include? @item.file_number
      assert response.body.include? items(:two).file_number
      assert response.body.include? items(:three).file_number
    end
  end

  test 'should get filtered index' do
    m = meetings(:two)

    VCR.use_cassette('google_maps_marshall') do
      get(items_url, params: { meeting_id: m.id })

      assert_response :success
      refute response.body.include? @item.file_number
      assert response.body.include? items(:two).file_number
      assert response.body.include? items(:three).file_number
    end
  end

  test 'should show item' do
    get item_url(@item)
    assert_response :success
  end
end
