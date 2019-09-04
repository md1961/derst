require 'test_helper'

class SiresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sires_index_url
    assert_response :success
  end

end
