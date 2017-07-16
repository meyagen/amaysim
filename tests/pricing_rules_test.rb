require 'minitest/autorun'
require_relative './helpers/minitest_helper'
require_relative '../src/pricing_rules'
require_relative '../src/sim_card'

class PricingRulesUnitTest < Minitest::Test
  describe 'PricingRules' do
    before do
      @rules = PricingRules.new

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

    describe 'apply freebies' do
      it 'applies freebies' do
        purchased_items = [ult_small, ult_medium, ult_medium]
        freebies = @rules.get_freebies(purchased_items)

        free_gb = SimCard.new('1gb', '1 GB Data-pack', 0)
        assert_equal [free_gb, free_gb], freebies
      end
    end

    describe 'apply bundle promos' do
      it 'returns purchased items with bundle modifications' do
        purchased_items = [ult_small, ult_small, ult_small]
        purchased_items = @rules.apply_bundle_promos(purchased_items)

        free_ult_small = SimCard.new('ult_small', 'Unlimited 1GB', 0)
        expected_purchases = [free_ult_small, ult_small, ult_small]

        assert_equal expected_purchases, purchased_items
      end
    end

    describe 'apply bulk discounts' do
      it 'returns purchased items with prices discounted' do
        purchased_items = [ult_large, ult_large, ult_large, ult_large]
        purchased_items = @rules.apply_bulk_discounts(purchased_items)

        discounted_ult_large = SimCard.new('ult_large', 'Unlimited 5GB', 39.90)
        expected_purchases = [
          discounted_ult_large, discounted_ult_large,
          discounted_ult_large, discounted_ult_large
        ]

        assert_equal expected_purchases, purchased_items
      end
    end

    describe 'apply promo codes' do
      it 'returns total discounted price' do
        total_purchases = @rules.apply_promo_codes(100, ['I<3AMAYSIM'])
        assert_equal 90, total_purchases
      end
    end
  end
end
