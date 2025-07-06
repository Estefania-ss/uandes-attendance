require "test_helper"

class RoomAssignmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get room_assignments_index_url
    assert_response :success
  end

  test "should get show" do
    get room_assignments_show_url
    assert_response :success
  end

  test "should get create" do
    get room_assignments_create_url
    assert_response :success
  end

  test "should get update" do
    get room_assignments_update_url
    assert_response :success
  end

  test "should get destroy" do
    get room_assignments_destroy_url
    assert_response :success
  end
end
