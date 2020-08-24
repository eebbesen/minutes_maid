# frozen_string_literal: true

##
module ApplicationHelper
  def header(page_title)
    content_for(:header) { page_title }
  end
end
