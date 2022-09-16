require "test_helper"

class Api::ExploresControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get api_explores_search_url
    assert_response :success
  end
end
