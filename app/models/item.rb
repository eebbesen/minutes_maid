# frozen_string_literal: true

##
class Item < ApplicationRecord
  belongs_to :meeting
  has_many :notes

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

  def user_notes(user_id)
    notes.where(user_id: user_id)
  end
end
