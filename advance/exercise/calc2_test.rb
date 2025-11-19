require 'minitest/autorun'
require_relative 'calc2'

class CalculatorTest < Minitest::Test
  def test_evaluate_returns_nil
    assert_nil Calculator.evaluate
  end
end