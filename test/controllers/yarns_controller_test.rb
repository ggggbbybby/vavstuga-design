require 'test_helper'

class YarnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @yarn = yarns(:one)
  end

  test "should get index" do
    get yarns_url
    assert_response :success
  end

  test "should get new" do
    get new_yarn_url
    assert_response :success
  end

  test "should create yarn" do
    assert_difference('Yarn.count') do
      post yarns_url, params: { yarn: {  } }
    end

    assert_redirected_to yarn_url(Yarn.last)
  end

  test "should show yarn" do
    get yarn_url(@yarn)
    assert_response :success
  end

  test "should get edit" do
    get edit_yarn_url(@yarn)
    assert_response :success
  end

  test "should update yarn" do
    patch yarn_url(@yarn), params: { yarn: {  } }
    assert_redirected_to yarn_url(@yarn)
  end

  test "should destroy yarn" do
    assert_difference('Yarn.count', -1) do
      delete yarn_url(@yarn)
    end

    assert_redirected_to yarns_url
  end
end
