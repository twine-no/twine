module WelcomeHelper
  def example_page
    Page.new(
      handle: "ingrid",
      name: "Ingrid's Bakery",
      bio: "Sourdough, cinnamon buns and good coffee in Bergen.",
      links: [
        Link.new(name: "Order for pickup", url: "example.com/order"),
        Link.new(name: "This week's menu", url: "example.com/menu"),
        Link.new(name: "Instagram", url: "example.com/instagram"),
        Link.new(name: "Say hello", url: "ingrid@example.com")
      ]
    )
  end
end
