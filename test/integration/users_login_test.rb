require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:batman)
  end

  test "login with invalid information" do 
    get login_path
    assert_template "sessions/new"
    post login_path, session: {email: "", password: ""}
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
    
  end
 
  test "login with valid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, session: {email: @user.email , password: "IAmBatman"}
    assert_redirected_to @user
    follow_redirect!
    assert_select "[href=?]", login_path, count:0
    assert_select "[href=?]", logout_path
    assert_select "[href=?]", user_path(@user)
    
    # log out
    delete logout_path
    assert_not is_logged_in? 
    assert_redirected_to root_path
    follow_redirect!
    assert_select "[href=?]", login_path, count:1
    assert_select "[href=?]", logout_path, count:0
    assert_select "[href=?]", user_path(@user), count:0
  end

end
