require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout_links" do
    get root_path
    assert_select "title", full_title
    assert_template 'static_pages/home'

    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path

    get help_path
    assert_select "title", full_title("Help")
    assert_template 'static_pages/help'

    get about_path
    assert_select "title", full_title("About")
    assert_template 'static_pages/about'

    get contact_path
    assert_select "title", full_title("Contact")
    assert_template 'static_pages/contact'

    get signup_path
    assert_select "title", full_title("Sign up")
    assert_template 'users/new'
  end
end
