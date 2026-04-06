module Users
  module Memberships
    class AssessmentsController < ApplicationController
      before_action :set_membership

      def create
        value = params[:value].to_i.clamp(0, 100)

        @membership.transaction do
          @membership.assessments.create!(value: value)
          @membership.update!(feeling: value)
        end

        Turbo::StreamsChannel.broadcast_replace_to(
          [Current.user, :memberships],
          target: ActionView::RecordIdentifier.dom_id(@membership, :assessment),
          partial: "users/assessments/slider",
          locals: { membership: @membership }
        )

        head :ok
      end

      private

      def set_membership
        @membership = Current.user.memberships.find(params[:membership_id])
      end
    end
  end
end
