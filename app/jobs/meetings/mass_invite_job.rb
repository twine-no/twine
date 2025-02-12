module Meetings
  class MassInviteJob < ApplicationJob
    def perform(meeting, invite_group:)
      ActiveRecord::Base.transaction do
        meeting.invitable_memberships(from: invite_group).each do |member|
          meeting.invites.create!(membership_id: member.id)
        end
      end
    end
  end
end
