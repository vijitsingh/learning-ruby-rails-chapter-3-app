require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:batman)
    @other_user = users(:joker)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect on edit for non-logged in user" do
    get :edit, id: @user # this automatically does id : @user.id
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect on update for non-logged in user" do
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect on edit for a different logged in user" do
    log_in_as(@other_user)
    get :edit, id: @user # this automatically does id : @user.id
    assert_redirected_to root_url
  end

  test "should redirect on update for a different logged in user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

end
