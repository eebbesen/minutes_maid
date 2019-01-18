# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :file_number
      t.integer :version
      t.string :name
      t.string :item_type
      t.string :title
      t.string :action
      t.string :result
      t.belongs_to :meeting, foreign_key: true

      t.timestamps
    end
  end
end
