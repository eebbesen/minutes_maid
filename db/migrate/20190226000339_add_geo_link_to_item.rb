# frozen_string_literal: true

class AddGeoLinkToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :geo_link, :string
  end
end
