# frozen_string_literal: true

require 'application_system_test_case'

class NotesTest < ApplicationSystemTestCase
  setup do
    sign_in users(:user_one)
    @note = notes(:note_one)
  end

  test 'visiting the index' do
    visit notes_url
    assert_selector 'h1', text: 'My Notes'
  end

  test 'creating a Note' do
    visit "#{notes_url}?item_id=#{@note.item.id}"
    click_on 'New Note'

    fill_in 'Text', with: @note.text
    click_on 'Create Note'

    assert_text 'Note was successfully created'
    click_on 'Back'
  end

  test 'No Create Note option without item' do
    visit notes_url
    click_on 'New Note'

    assert_equal 0, page.all(:css, '#notes-button').count
  end

  test 'updating a Note' do
    visit notes_url
    page.find(:css, '.pointer', match: :first).click

    fill_in 'Text', with: @note.text
    click_on 'Update Note'

    assert_text 'Note was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Note' do
    visit notes_url
    page.accept_confirm do
      click_on 'Delete', match: :first
    end

    assert_text 'Note was successfully destroyed'
  end

  test 'no Notes button, but Meetings and Items' do
    visit notes_url

    assert find(:css, '#meetings-button')
    assert find(:css, '#items-button')
    assert_equal 0, page.all(:css, '#notes-button').count
  end
end
