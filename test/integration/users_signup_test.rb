require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do 
    get signup_path
    user_count_before = User.count
    post users_path, user: {name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
    user_count_after = User.count
    assert_equal user_count_before, user_count_after
    assert_template "users/new"
  end
  
  test "valid signup information" do
    get signup_path
    user_count_before = User.count
    post_via_redirect users_path, user: {name: "vijit", email: "vijit@example.com", password: "password", password_confirmation: "password" }
    user_count_after = User.count
    assert_equal user_count_before + 1, user_count_after 
 #   assert_template "users/show"
  #  assert is_logged_in?
  end
end
