class AddTitleToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :title, :string
  end
end
