require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "vijit", email: "vijit@amazon.com", password: "darling", password_confirmation: "darling")
  end 

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be test"  do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should NOT exceed max_length" do 
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should NOT exceed max_length" do 
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "valid addresses should be accepted" do
    email_addresses = %w[user@example.com user33.33@example.com user_22@example34.in]

    email_addresses.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "invalid addresses should NOT be accepted" do
    email_addresses = %w[@example.com user33.33@example,com user_22@.in]

    email_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should NOT be valid"
    end
  end
  
  test "only unique email address should be allowed" do 
    duplicate_user = @user.dup
    duplicate_user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
end
