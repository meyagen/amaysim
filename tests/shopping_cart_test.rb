require 'minitest/autorun'
require_relative './helpers/minitest_helper'
require_relative '../src/pricing_rules'
require_relative '../src/shopping_cart'
require_relative '../src/sim_card'

class ShoppingCartTest < Minitest::Test
  describe 'ShoppingCart' do
    before do
      rules = PricingRules.new
      @cart = ShoppingCart.new(rules)

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

    it 'initializes correctly' do
      assert_equal [], @cart.purchased_items
      assert_equal [], @cart.promo_codes
      assert_equal [], @cart.freebies
    end

    describe 'add item' do
      it 'adds an item' do
        assert_equal [], @cart.items

        @cart.add(ult_small)
        assert_equal [ult_small], @cart.items
      end

      it 'adds an item with promo' do
        assert_equal [], @cart.items
        assert_equal [], @cart.promo_codes

        @cart.add(ult_small, 'I<3AMAYSIM')

        assert_equal [ult_small], @cart.items
        assert_equal ['I<3AMAYSIM'], @cart.promo_codes
      end
    end

    describe 'add promo code' do
      it 'adds a promo code' do
        assert_equal [], @cart.promo_codes
        @cart.add_promo_code('I<3AMAYSIM')

        assert_equal ['I<3AMAYSIM'], @cart.promo_codes
      end

      it 'ignores an empty promo code' do
        assert_equal [], @cart.promo_codes
        @cart.add_promo_code(nil)

        assert_equal [], @cart.promo_codes
      end

      it 'ignores an invalid promo code' do
        assert_equal [], @cart.promo_codes
        @cart.add_promo_code('AMAYSIM')

        assert_equal [], @cart.promo_codes
      end

      it 'adds the promo only once' do
        assert_equal [], @cart.promo_codes

        @cart.add(ult_small, 'I<3AMAYSIM')
        @cart.add(ult_small, 'I<3AMAYSIM')

        assert_equal ['I<3AMAYSIM'], @cart.promo_codes
      end
    end

    describe 'total' do
      it 'gets the sum of prices' do
        @cart.add(ult_small)
        @cart.add(ult_small)

        assert_equal 49.8, @cart.total
      end

      it 'applies bundle promos' do
        @cart.add(ult_small)
        @cart.add(ult_small)
        @cart.add(ult_small)
        
        assert_equal 49.8, @cart.total
      end

      it 'applies bulk discounts' do
        @cart.add(ult_large)
        @cart.add(ult_large)
        @cart.add(ult_large)
        @cart.add(ult_large)

        assert_equal 159.6, @cart.total
      end

      it 'applies freebies' do
        @cart.add(ult_small)
        @cart.add(ult_medium)
        @cart.add(ult_medium)
        @cart.total

        free_gb = gb
        free_gb.price = 0

        assert_equal 84.7, @cart.total
        assert_equal [free_gb, free_gb], @cart.freebies
      end

      it 'applies promo codes' do
        @cart.add(ult_small)
        @cart.add(ult_small, 'I<3AMAYSIM')

        assert_equal 44.82, @cart.total
      end
    end
  end
end
