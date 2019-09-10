require 'test_helper'

class MatingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get matings_index_url
    assert_response :success
  end

  test "should get show" do
    get matings_show_url
    assert_response :success
  end

end
