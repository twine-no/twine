class RemoveContentFromMessages < ActiveRecord::Migration[8.0]
  def change
    remove_column :messages, :content, :text
  end
end
