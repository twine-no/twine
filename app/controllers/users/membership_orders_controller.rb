module Users
  class MembershipOrdersController < ApplicationController
    def update
      ActiveRecord::Base.transaction do
        params[:order].each_with_index do |id, index|
          Current.user.memberships.where(id: id).update_all(position: index)
        end
      end

      head :ok
    end
  end
end
