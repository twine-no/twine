require "test_helper"

class PageTest < ActiveSupport::TestCase
  test "#save turns the handle into something that fits in an address" do
    page = Page.create!(user: users(:new_recruit), handle: " Blåbær Café ")
    assert_equal "blabaer-cafe", page.handle
  end

  test "#save fails when the handle is taken" do
    assert_not Page.new(user: users(:new_recruit), handle: pages(:bakery).handle.upcase).save
  end

  test "#title falls back to the handle when the page has no name" do
    assert_equal "Spring Bakery", pages(:bakery).title
    assert_equal "@dave", pages(:daves_draft).title
  end
end
