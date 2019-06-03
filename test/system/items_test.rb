# frozen_string_literal: true

require 'application_system_test_case'

class ItemsTest < ApplicationSystemTestCase
  setup do
    @item = items(:item_one)
  end

  test 'visiting the items index for all items' do
    visit items_url
    assert_selector 'h1', text: 'Items'
  end

  test 'filter resolution lh' do
    visit items_url
    assert_equal 4, page.all(:css, 'tr.data').size
    find(:css, '#item-filter').find(:option, 'Resolution LH').select_option
    assert_equal 3, page.all(:css, 'tr.data').size
  end

  test 'no Items button, but Meetings button' do
    visit items_url
    assert find(:css, '#meetings-button')
    assert_equal 0, page.all(:css, '#items-button').count
  end

  test 'No Notes button when not logged in' do
    visit items_url
    assert_equal 0, page.all(:css, '#notes-button').count
  end

  test 'Notes button when logged in' do
    sign_in users(:user_one)
    visit items_url
    assert find(:css, '#notes-button')
  end

  test 'No notes button when logged out' do
    visit items_url
    assert_equal 0, page.all(:css, '#notes-button').count
  end
end
