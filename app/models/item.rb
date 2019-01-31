# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :meeting

  def hclass
    case item_type
    when /^Resolution LH/
      'rlh'
    when 'Resolution'
      'res'
    else
      'gen'
    end
  end
end
