# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :meeting
end
