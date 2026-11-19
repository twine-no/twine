class LinksController < ApplicationController
  before_action :set_link, only: %i[ update destroy ]

  def create
    @link = Current.user.page.links.new(link_params)

    if @link.save
      redirect_to edit_page_path
    else
      redirect_to edit_page_path, alert: @link.errors.full_messages.to_sentence
    end
  end

  def update
    if @link.update(link_params)
      redirect_to edit_page_path
    else
      redirect_to edit_page_path, alert: @link.errors.full_messages.to_sentence
    end
  end

  def destroy
    @link.destroy!
    redirect_to edit_page_path
  end

  private

  def set_link
    @link = Current.user.page.links.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:name, :url)
  end
end
