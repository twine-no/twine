class PivotToLinktree < ActiveRecord::Migration[8.0]
  class LegacyPlatform < ActiveRecord::Base
    self.table_name = "platforms"
  end

  class LegacyMembership < ActiveRecord::Base
    self.table_name = "memberships"
  end

  class LegacyLink < ActiveRecord::Base
    self.table_name = "links"
  end

  class LegacyAttachment < ActiveRecord::Base
    self.table_name = "active_storage_attachments"
  end

  # Membership roles were stored as integers: member 0, admin 1, super_admin 2, invited 3
  SUPER_ADMIN_ROLE = 2
  ADMIN_ROLE = 1

  REMOVED_TABLES = %i[
    assessments
    surveys_alternatives_responses
    surveys_responses
    surveys_alternatives
    surveys_questions
    surveys
    rsvps
    invites
    meeting_log_entries
    messages
    groups_memberships
    groups
    meetings
    memberships
    action_text_rich_texts
  ].freeze

  def up
    add_reference :platforms, :user, foreign_key: true, index: { unique: true }

    assign_each_platform_to_one_owner
    remove_platforms_with_nothing_to_keep
    LegacyPlatform.where(user_id: nil).pluck(:shortname).each do |shortname|
      say "@#{shortname} is left without an owner, because each of its admins already has a page"
    end
    LegacyLink.where.not(platform_id: LegacyPlatform.select(:id)).delete_all
    LegacyAttachment.where(record_type: "Platform", name: "logo").update_all(record_type: "Page", name: "avatar")
    LegacyAttachment.where(record_type: "ActionText::RichText").delete_all

    REMOVED_TABLES.each { |table_name| drop_table table_name }

    remove_reference :sessions, :platform, foreign_key: true, index: true
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :registered_at, :datetime

    remove_column :platforms, :calendar_tagline, :string
    remove_column :platforms, :category, :string
    rename_column :platforms, :shortname, :handle
    rename_column :platforms, :tagline, :bio
    rename_column :platforms, :listed, :published
    change_column_default :platforms, :published, from: nil, to: true
    change_column_null :platforms, :published, false, false
    change_column_null :platforms, :name, true
    rename_table :platforms, :pages

    rename_column :links, :platform_id, :page_id
    add_foreign_key :links, :pages
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  # An account now has exactly one page. Published platforms with the most links are handed out first,
  # so somebody who ran several platforms keeps the one that is actually in use.
  def assign_each_platform_to_one_owner
    link_counts = LegacyLink.group(:platform_id).count
    owner_ids = []

    platforms_in_order_of_importance(link_counts).each do |platform|
      owner_id = LegacyMembership
        .where(platform_id: platform.id, role: [ SUPER_ADMIN_ROLE, ADMIN_ROLE ])
        .where.not(user_id: owner_ids)
        .order(role: :desc, id: :asc)
        .pick(:user_id)

      next unless owner_id

      platform.update_columns(user_id: owner_id)
      owner_ids << owner_id
    end
  end

  def platforms_in_order_of_importance(link_counts)
    LegacyPlatform.all.sort_by do |platform|
      [ platform.listed ? 0 : 1, -link_counts.fetch(platform.id, 0), platform.id ]
    end
  end

  def remove_platforms_with_nothing_to_keep
    LegacyPlatform
      .where(user_id: nil)
      .where(listed: [ nil, false ])
      .where.not(id: LegacyLink.select(:platform_id))
      .delete_all
  end
end
