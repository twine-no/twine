module Admin
  module Memberships
    class FeelingsController < ApplicationController
      def update
        membership = Current.user.memberships.find(params[:membership_id])
        membership.update!(feeling: params[:feeling].to_i.clamp(0, 100))
        head :ok
      end
    end
  end
end
