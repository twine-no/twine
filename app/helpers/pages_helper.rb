module PagesHelper
  def page_address_prefix
    "#{request.host_with_port}/@"
  end

  def page_address(page)
    page.domain.presence || "#{page_address_prefix}#{page.handle}"
  end

  def page_avatar_file_types
    Page::AVATAR_CONTENT_TYPES.join(",")
  end

  def page_share_url(page)
    page.domain.present? ? "https://#{page.domain}" : public_page_url(page.handle)
  end

  def page_browser_title(page)
    on_custom_domain? ? page.title : "#{page.title} | Twine"
  end

  def page_image_url(page)
    page.avatar.attached? ? rails_storage_proxy_url(page.avatar.variant(:thumbnail)) : image_url("logo.png")
  end

  def page_background_style(page)
    if page.color.present?
      "background-color: ##{page.color.delete_prefix('#')};"
    elsif page.avatar.attached?
      "background-image: url(#{rails_storage_proxy_path(page.avatar.variant(:thumbnail))});"
    end
  end
end
