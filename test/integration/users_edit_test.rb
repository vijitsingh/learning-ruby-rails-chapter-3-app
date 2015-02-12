require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # enda

  def setup
    @user = users(:batman)
  end

  test "invalid edit information" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), user: { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar" }
    assert_template "users/edit"

  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    patch user_path(@user), user: { name: "bar", email: "foo@invalid.com", password: "", password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "bar"
    assert_equal @user.email, "foo@invalid.com"
  end
  
end

