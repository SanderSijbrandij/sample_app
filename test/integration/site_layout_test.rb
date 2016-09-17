require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "layout_links without login" do
    # root (and nav links)
    get root_path
    assert_select "title", full_title
    assert_template 'static_pages/home'

    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path

    # static_pages/help
    get help_path
    assert_select "title", full_title("Help")
    assert_template 'static_pages/help'

    # static_pages/about
    get about_path
    assert_select "title", full_title("About")
    assert_template 'static_pages/about'

    # static_pages/contact
    get contact_path
    assert_select "title", full_title("Contact")
    assert_template 'static_pages/contact'

    # users#new
    get signup_path
    assert_select "title", full_title("Sign up")
    assert_template 'users/new'

    # users#show
    get user_path(@user)
    assert_template 'users/show'

    # users#index
    get users_path
    assert_redirected_to login_url

    # users#edit
    get edit_user_path(@user)
    assert_redirected_to login_url
  end

  test "layout links with login" do
    log_in_as(@user)

    # root (and nav links)
    get root_path
    assert_template "static_pages/home"

    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path

    # users#index
    get users_path
    assert_select "title", full_title("All users")
    assert_template 'users/index'

    # users#edit
    get edit_user_path(@user)
    assert_template 'users/edit'

    # sessions#destroy (logout)
    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]", login_path
  end
end
