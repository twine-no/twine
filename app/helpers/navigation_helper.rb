module NavigationHelper
  def admin_page?
    request.path.include?('/admin/')
  end

  def member_page?
    request.path.include?('/member/')
  end
end
