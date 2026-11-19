module Links
  class OrdersController < ApplicationController
    def update
      Link.transaction do
        params.require(:link_ids).each_with_index do |link_id, position|
          Current.user.page.links.find(link_id).update!(position: position)
        end
      end

      redirect_to edit_page_path
    end
  end
end
