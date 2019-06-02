# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase

  test 'create user sign up initially disabled' do
    require_recaptcha
    visit new_user_registration_url

    assert page.has_css?(".actions input[disabled='disabled']")
  end

  test 'create user without email fails' do
    require_recaptcha false
    visit new_user_registration_url
    fill_in 'Password', with: 'abcd1234'
    fill_in 'Password confirmation', with: 'abcd1234'
    click_on 'Sign up'

    assert_text "Email can't be blank"
  end

   test 'create user without matching passwords fails' do
    require_recaptcha false
    visit new_user_registration_url
    fill_in 'Email', with: 'mm@minutesmaid.gmail.com'
    fill_in 'Password', with: 'abcd1234'
    fill_in 'Password confirmation', with: 'abcd12345'
    click_on 'Sign up'

    assert_text "Password confirmation doesn't match Password"
  end

  test 'create user Sign up disabled until reCAPTCHA successful' do
    require_recaptcha
    visit new_user_registration_url

    fill_in 'Email', with: 'mm@minutesmaid.gmail.com'
    fill_in 'Password', with: 'abcd1234'
    fill_in 'Password confirmation', with: 'abcd1234'

    assert page.has_css?(".actions input[disabled='disabled']")
  end

  test 'create user nothing populated' do
    require_recaptcha false
    visit new_user_registration_url
    click_on 'Sign up'

    assert_text "Email can't be blank"
    assert_text "Password can't be blank"
  end

  private

  def require_recaptcha(y=true)
    return Recaptcha.configuration.skip_verify_env.delete('test') if y
    Recaptcha.configuration.skip_verify_env.push('test') unless Recaptcha.configuration.skip_verify_env.include?('test')
  end
end
