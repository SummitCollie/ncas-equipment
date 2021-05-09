require 'test_helper'

class BarcodesControllerTest < ActionDispatch::IntegrationTest
  test 'should get scanner' do
    get barcodes_scanner_url
    assert_response :success
  end
end
