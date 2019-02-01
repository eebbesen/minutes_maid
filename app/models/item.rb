# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :meeting

  def hclass
    case item_type
    when /^Resolution LH/
      'rlh'
    when /^Resolution-Public/
      'rlp'
    when 'Resolution'
      'res'
    else
      item_type.split(' ').first.downcase
    end
  end
end
