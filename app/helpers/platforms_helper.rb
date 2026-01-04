module PlatformsHelper
  def platform_site_title(platform)
    if platform.custom_domain?
      platform.name
    else
      "#{platform.name} | Twine"
    end
  end
end
