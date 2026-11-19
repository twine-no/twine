class PagesController < ApplicationController
  before_action :set_page, only: %i[ edit update ]
  before_action :ensure_user_has_no_page, only: %i[ new create ]

  def new
    @page = Page.new
  end

  def create
    @page = Current.user.build_page(page_params)

    if @page.save
      redirect_to edit_page_path, notice: "Your linktree is live."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to edit_page_path
    else
      redirect_to edit_page_path, alert: @page.errors.full_messages.to_sentence
    end
  end

  private

  def set_page
    @page = Current.user.page
    redirect_to new_page_path unless @page
  end

  def ensure_user_has_no_page
    redirect_to edit_page_path if Current.user.page
  end

  def page_params
    params.require(:page).permit(:avatar, :name, :bio, :handle, :published)
  end
end
