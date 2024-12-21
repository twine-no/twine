module ImagesHelper
  def svg_tag(icon_name, options = {})
    icon_name.sub!(".svg", "")

    if Rails.env.production?
      cache_key = "svg-#{icon_name}-#{options.hash}"
      Rails.cache.fetch(cache_key) do
        generate_svg_tag(icon_name, options)
      end
    else
      generate_svg_tag(icon_name, options)
    end
  end

  private

  def generate_svg_tag(icon_name, options)
    file = Rails.root.join("app", "assets", "images", "#{icon_name}.svg").read
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    options.each { |attr, value| svg[attr.to_s] = value }
    doc.to_html.html_safe
  end
end
