require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transactions_index_url
    assert_response :success
  end

  test "should get update" do
    get transactions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get transactions_destroy_url
    assert_response :success
  end

end
