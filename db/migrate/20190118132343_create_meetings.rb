# frozen_string_literal: true

class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.string :name
      t.date :date
      t.string :details
      t.string :agenda
      t.string :minutes

      t.timestamps
    end
  end
end
