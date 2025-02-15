  class AddTimestampsToPlatforms < ActiveRecord::Migration[8.0]
    def change
      add_timestamps :platforms
    end
  end
