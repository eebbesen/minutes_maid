# frozen_string_literal: true

class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.string :text
      t.belongs_to :item
      t.belongs_to :user

      t.timestamps
    end
  end
end
