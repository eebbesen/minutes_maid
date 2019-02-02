# frozen_string_literal: true

class Meeting < ApplicationRecord
  has_many :items

  def hclass
    case name
    when /^Board/
      'water'
    when nil
      ''
    else
      name.split(' ').first.downcase
    end
  end

  def filename
    "#{name.gsub(' ', '_').downcase}-#{date}.pdf"
  end
end
