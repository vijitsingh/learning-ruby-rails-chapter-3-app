require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "ordering is correct" do 
    assert_equal Micropost.first, microposts(:most_recent)
  end 
end
