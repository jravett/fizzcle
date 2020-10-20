require 'test_helper'

class ReportControllerTest < ActionDispatch::IntegrationTest
  test "should get tag" do
    get report_tag_url
    assert_response :success
  end

end
