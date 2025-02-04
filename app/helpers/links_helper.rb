module LinksHelper
  def links_name_placeholder
    example_name = [
      "Our Discord Server",
      "Our YouTube Channel",
      "Become a Member"
    ].sample
    "i.e. \"#{example_name}\""
  end
end
