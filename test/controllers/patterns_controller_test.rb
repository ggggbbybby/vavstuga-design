require 'test_helper'

class PatternsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pattern = patterns(:one)
  end

  test "should get index" do
    get patterns_url
    assert_response :success
  end

  test "should get new" do
    get new_pattern_url
    assert_response :success
  end

  test "should create pattern" do
    assert_difference('Pattern.count') do
      post patterns_url, params: { pattern: {  } }
    end

    assert_redirected_to pattern_url(Pattern.last)
  end

  test "should show pattern" do
    get pattern_url(@pattern)
    assert_response :success
  end

  test "should get edit" do
    get edit_pattern_url(@pattern)
    assert_response :success
  end

  test "should update pattern" do
    patch pattern_url(@pattern), params: { pattern: {  } }
    assert_redirected_to pattern_url(@pattern)
  end

  test "should destroy pattern" do
    assert_difference('Pattern.count', -1) do
      delete pattern_url(@pattern)
    end

    assert_redirected_to patterns_url
  end
end
