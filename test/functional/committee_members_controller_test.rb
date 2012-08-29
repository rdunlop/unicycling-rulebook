require 'test_helper'

class CommitteeMembersControllerTest < ActionController::TestCase
  setup do
    @committee_member = committee_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:committee_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create committee_member" do
    assert_difference('CommitteeMember.count') do
      post :create, committee_member: @committee_member.attributes
    end

    assert_redirected_to committee_member_path(assigns(:committee_member))
  end

  test "should show committee_member" do
    get :show, id: @committee_member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @committee_member
    assert_response :success
  end

  test "should update committee_member" do
    put :update, id: @committee_member, committee_member: @committee_member.attributes
    assert_redirected_to committee_member_path(assigns(:committee_member))
  end

  test "should destroy committee_member" do
    assert_difference('CommitteeMember.count', -1) do
      delete :destroy, id: @committee_member
    end

    assert_redirected_to committee_members_path
  end
end
