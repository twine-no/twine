module Users
  module Memberships
    class AssessmentsController < ApplicationController
      def create
        membership = Current.user.memberships.find(params[:membership_id])
        value = params[:value].to_i.clamp(0, 100)
        membership.assessments.create!(value: value)
        membership.update!(feeling: value)

        Turbo::StreamsChannel.broadcast_replace_to(
          [ Current.user, :memberships ],
          target: ActionView::RecordIdentifier.dom_id(membership, :assessment),
          partial: "users/assessments/slider",
          locals: { membership: membership }
        )

        head :ok
      end
    end
  end
end
