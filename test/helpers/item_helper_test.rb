# frozen_string_literal: true

require 'test_helper'

class ItemHelperTest < ActiveSupport::TestCase
  test 'links address with remove repair' do
    VCR.use_cassette('item_one') do
      item = items :one
      s = ItemHelper.loc_link item

      assert_equal 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=EioxMDAwMSBNYXJzaGFsbCBBdmVudWUsIFNhaW50IFBhdWwsIE1OLCBVU0E', s
    end
  end

  test 'links address with nothing' do
    item = items :four
    s = ItemHelper.loc_link item

    assert_equal '', s
  end

  test 'links address with text that is not address' do
    VCR.use_cassette('rlh_not_address') do
      h = {
        file_number: 'RLH TA 0-0',
        name: 'not an address',
        item_type: 'Resolution LH Tax Assessment Appeal'
      }

      item = Item.new h
      s = ItemHelper.loc_link item

      assert_equal '', s
    end
  end

  test 'links address with rlh ar' do
    h = {
      file_number: 'RLH AR 19-2',
      name: 'Excessive/Abatement Service July 23 to August 21, 2018',
      item_type: 'Resolution LH Assessment Roll'
    }

    item = Item.new h
    s = ItemHelper.loc_link item

    assert_equal '', s
  end

  test 'links address with rlh rr' do
    VCR.use_cassette('rlh_rr_address') do
      h = {
        file_number: 'RLH RR 0-0',
        name: '1600 Grand Ave Remove/Repair',
        item_type: 'Resolution LH Substantial Abatement Order'
      }

      item = Item.new h
      s = ItemHelper.loc_link item

      assert_equal 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=ChIJZW__ehcq9ocRYN-4nWCtgX4', s
    end
  end

  test 'clean remove/repair' do
    item = items :one
    n = ItemHelper.clean_name item.name

    assert_equal '10001 Marshall Avenue', n
  end
end
