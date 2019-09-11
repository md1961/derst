require 'test_helper'

class RanchesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get ranches_show_url
    assert_response :success
  end

end
