require "test_helper"

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  test "should get telegram" do
    get webhooks_telegram_url
    assert_response :success
  end
end
