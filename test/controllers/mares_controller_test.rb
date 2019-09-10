require 'test_helper'

class MaresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mares_index_url
    assert_response :success
  end

  test "should get show" do
    get mares_show_url
    assert_response :success
  end

end
