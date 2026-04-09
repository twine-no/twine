class AddFeelingToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :feeling, :integer
  end
end
