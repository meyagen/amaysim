require 'minitest/autorun'
require_relative './helpers/minitest_helper'
require_relative '../src/pricing_rules'
require_relative '../src/shopping_cart'
require_relative '../src/sim_card'

class ShoppingCartTest < Minitest::Test
  describe 'ShoppingCart Scenarios' do
    before do
      rules = PricingRules.new
      @cart = ShoppingCart.new rules

      def ult_small
        SimCard.new('ult_small', 'Unlimited 1GB', 24.90)
      end

      def ult_medium
        SimCard.new('ult_medium', 'Unlimited 2GB', 29.90)
      end

      def ult_large
        SimCard.new('ult_large', 'Unlimited 5GB', 44.90)
      end

      def gb
        SimCard.new('1gb', '1 GB Data-pack', 9.90)
      end
    end

    it 'passes scenario 1' do
      @cart.add(ult_small)
      @cart.add(ult_small)
      @cart.add(ult_small)
      @cart.add(ult_large)
      @cart.total

      expected_product_codes = ['ult_small', 'ult_small', 'ult_small', 'ult_large']
      assert_equal 94.70, @cart.total
      assert_equal expected_product_codes, @cart.items.map(&:code)
    end

    it 'passes scenario 2' do
      @cart.add(ult_small)
      @cart.add(ult_small)

      @cart.add(ult_large)
      @cart.add(ult_large)
      @cart.add(ult_large)
      @cart.add(ult_large)
      @cart.total

      expected_product_codes = [
        'ult_small', 'ult_small',
        'ult_large', 'ult_large',
        'ult_large', 'ult_large',
      ]

      assert_equal 209.40, @cart.total
      assert_equal expected_product_codes, @cart.items.map(&:code)
    end

    it 'passes scenario 3' do
      @cart.add(ult_small)
      @cart.add(ult_medium)
      @cart.add(ult_medium)

      expected_product_codes = [
        'ult_small',
        'ult_medium', 'ult_medium',
        '1gb', '1gb',
      ]

      assert_equal 84.70, @cart.total
      assert_equal expected_product_codes, @cart.items.map(&:code)
    end

    it 'passes scenario 4' do
      @cart.add(ult_small)
      @cart.add(gb, 'I<3AMAYSIM')

      expected_product_codes = ['ult_small', '1gb']

      assert_equal 31.32, @cart.total
      assert_equal expected_product_codes, @cart.items.map(&:code)
    end
  end
end
