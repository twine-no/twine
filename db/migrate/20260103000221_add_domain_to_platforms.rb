class AddDomainToPlatforms < ActiveRecord::Migration[8.0]
  def change
    add_column :platforms, :domain, :string
  end
end
