module Admin
  class GroupsMembershipsController < AdminController
    before_action :set_group, only: [:create, :destroy]

    # Create group memberships in bulk
    def create
      memberships = retrieve_memberships_that_can_be_added
      if memberships.any?
        Membership.transaction do
          memberships.each do |membership|
            next if membership.groups.include? @group

            membership.groups << @group
          end
        end

        redirect_to admin_memberships_path,
                    notice: "Added #{memberships.size} #{"member".pluralize(memberships.size)} to #{@group.name}"
      else
        redirect_to admin_memberships_path,
                    notice: "Could not add selected members to #{@group.name}"
      end
    end

    def destroy
      memberships = filter_memberships_that_can_be_removed_from(@group)
      if memberships.any?
        Membership.transaction do
          memberships.each do |membership|
            membership.groups.delete @group
          end
        end

        redirect_to admin_memberships_path(tab: @group.id),
                    notice: "Removed #{memberships.size} #{"member".pluralize(memberships.size)} from #{@group.name}"
      else
        redirect_to admin_memberships_path(tab: @group.id),
                    notice: "Could not remove selected members from #{@group.name}"
      end
    end

    private

    def set_group
      @group = Current.platform.groups.find(params[:group_id])
    end

    def retrieve_memberships_that_can_be_added
      membership_ids = params[:multi_select_ids]&.split(",")
      return Membership.none unless membership_ids&.any?

      Current.platform.memberships
             .where(id: membership_ids)
             .includes(:groups)
    end

    def filter_memberships_that_can_be_removed_from(group)
      membership_ids = params[:multi_select_ids]&.split(",")
      return Membership.none unless membership_ids&.any?

      group.memberships.where(id: membership_ids)
    end
  end
end
