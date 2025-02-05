  class AddTimestampsToPlatforms < ActiveRecord::Migration[8.0]
    def change
      add_timestamps :platforms, null: true

      # TODO :Remove these three statements and null: true above, once migration has run on server
      Platform.update_all(created_at: Time.current, updated_at: Time.current)
      change_column_null :platforms, :created_at, false
      change_column_null :platforms, :updated_at, false
    end
  end
