module Meetings
  class MassInviteJob < ApplicationJob
    def perform(meeting, invite_groups:)
      ActiveRecord::Base.transaction do
        invite_groups.each do |invite_group|
          meeting.invitable_memberships(from: invite_group).each do |member|
            meeting.invites.create!(membership_id: member.id)
          end
        end
      end
    end
  end
end
