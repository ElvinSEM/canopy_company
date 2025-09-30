require "test_helper"

class PortfolioItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get portfolio_items_index_url
    assert_response :success
  end

  test "should get new" do
    get portfolio_items_new_url
    assert_response :success
  end

  test "should get create" do
    get portfolio_items_create_url
    assert_response :success
  end

  test "should get edit" do
    get portfolio_items_edit_url
    assert_response :success
  end

  test "should get update" do
    get portfolio_items_update_url
    assert_response :success
  end

  test "should get destroy" do
    get portfolio_items_destroy_url
    assert_response :success
  end
end
