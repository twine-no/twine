require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test "#save adds https to an address without it" do
    link = pages(:bakery).links.create!(name: "Shop", url: " blåbær.example/shop ")
    assert_equal "https://blåbær.example/shop", link.url
  end

  test "#save turns an email address into a mailto address" do
    link = pages(:bakery).links.create!(name: "Say hello", url: "hello@springbakery.example")
    assert_equal "mailto:hello@springbakery.example", link.url
  end

  test "#save refuses addresses that are not plain web or email addresses" do
    [
      "javascript:alert(1)",
      "data:text/html,<script>alert(1)</script>",
      "https://bank.example@evil.example",
      "https://spring bakery.example",
      "mailto:not-an-email"
    ].each do |address|
      assert_not pages(:bakery).links.new(name: "Click me", url: address).save, "#{address} should be refused"
    end
  end
end
