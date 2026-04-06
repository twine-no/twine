module Users
  module Memberships
    class FeelingsController < ApplicationController
      def update
        membership = Current.user.memberships.find(params[:membership_id])
        membership.update!(feeling: params[:feeling].to_i.clamp(0, 100))

        Turbo::StreamsChannel.broadcast_replace_to(
          [ Current.user, :memberships ],
          target: ActionView::RecordIdentifier.dom_id(membership, :feeling),
          partial: "users/memberships/feeling_slider",
          locals: { membership: membership }
        )

        head :ok
      end
    end
  end
end
