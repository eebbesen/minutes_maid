# frozen_string_literal: true

require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:item_one)
    @items = items(:item_one, :item_two, :item_three, :item_four)
  end

  test 'should get index' do
    VCR.use_cassette('google_maps_marshall_two') do
      get items_url

      assert_response :success
      assert response.body.include? @item.file_number
      assert response.body.include? items(:item_two).file_number
      assert response.body.include? items(:item_three).file_number
    end
  end

  test 'should get filtered index' do
    m = meetings(:meeting_two)

    VCR.use_cassette('google_maps_marshall') do
      get(items_url, params: { meeting_id: m.id })

      assert_response :success
      refute response.body.include? @item.file_number
      assert response.body.include? items(:item_two).file_number
      assert response.body.include? items(:item_three).file_number
    end
  end

  test 'should show item' do
    get item_url(@item)
    assert_response :success
  end

  test 'should return csv content' do
    # Note: success required adding show.csv.erb even though that file was not required for a functional human test,
    # so I have reservations about the quality of this test.

    # Also, admittedly this test is not very deep. I experimented with ways to actually test the CSV output, but I
    # didn't learn enough yet to accomplish that
    get item_url(@items), params: { format: 'csv' }
    assert_response :success
  end
end
