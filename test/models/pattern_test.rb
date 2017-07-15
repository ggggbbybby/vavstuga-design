require 'test_helper'

class PatternTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def pattern
    @pattern ||= Pattern.new
  end

  test "autoscale a narrow pattern" do
    pattern.stripes = [['a', 1], ['b', 1], ['a', 1]]
    assert_equal([['a', 34], ['b', 34], ['a', 34]], pattern.scaled_stripes)
  end

  test "autoscale a wide pattern" do
    pattern.stripes = [['a', 100], ['b', 6], ['a', 6], ['b', 6], ['a', 100]]
    assert_equal([['a', 46], ['b', 3], ['a', 3], ['b', 3], ['a', 46]], pattern.scaled_stripes)
  end

  test "autoscale doesn't lose stripes" do
    pattern.stripes = [['a', 1000], ['b', 1]]
    assert_equal([['a', 100], ['b', 1]], pattern.scaled_stripes)
  end
end
