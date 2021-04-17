require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get tags_search_url
    assert_response :success
  end
end
