class AddLinkToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :link, :string
  end
end
