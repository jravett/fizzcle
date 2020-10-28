require 'test_helper'

class PayeesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get payees_index_url
    assert_response :success
  end

  test "should get edit" do
    get payees_edit_url
    assert_response :success
  end

end
