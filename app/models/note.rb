# frozen_string_literal: true

##
class Note < ApplicationRecord
  belongs_to :item
  belongs_to :user
end
