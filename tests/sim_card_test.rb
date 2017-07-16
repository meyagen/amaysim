require 'minitest/autorun'
require_relative './helpers/minitest_helper'
require_relative '../src/sim_card'

class SimCardUnitTest < Minitest::Test
  def setup
    @product = SimCard.new('ult_small', 'Unlimited 1GB', 24.90)
  end

  def test_constructor
    assert_equal 'ult_small', @product.code
    assert_equal 'Unlimited 1GB', @product.name
    assert_equal 24.90, @product.price
  end

  def test_equality
    new_product = SimCard.new('ult_small', 'Unlimited 1GB', 24.90)
    assert_equal new_product, @product 
  end
end
