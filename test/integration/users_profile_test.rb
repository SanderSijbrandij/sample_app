require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    log_in_as(@user)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    # Own Profile, before following
    assert_select 'strong#following', text: '2'
    assert_select 'strong#followers', text: '2'
    assert_select 'div#follow_form', count: 0

    # Other Profile, after following
    @user.follow(@other_user)
    get user_path(@other_user)

    assert_select 'strong#followers', text: '1'
    assert_select 'strong#following', text: '1'
    assert_select 'div#follow_form', count: 1
    assert_match  'Unfollow', response.body

    # Unfollow and reverse
    @user.unfollow(@other_user)
    @other_user.unfollow(@user)
    get user_path(@other_user)

    assert_select 'strong#followers', text: '0'
    assert_select 'strong#following', text: '0'
    assert_match  'Follow', response.body
  end
end
