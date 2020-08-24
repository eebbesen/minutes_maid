# frozen_string_literal: true

# from https://github.com/plataformatec/devise/wiki/How-To:-Use-Recaptcha-with-Devise

##
class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  private

  def check_captcha
    return if verify_recaptcha

    self.resource = resource_class.new sign_up_params
    resource.validate # Look for any other validation errors besides Recaptcha
    set_minimum_password_length
    respond_with resource
  end
end
