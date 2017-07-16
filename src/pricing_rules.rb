class PricingRules
  def apply_pricing_rules(purchased_items)
    purchased_items = apply_bundle_promos(purchased_items)
    purchased_items = apply_bulk_discounts(purchased_items)

    return purchased_items
  end

  def apply_bundle_promos(purchased_items)
    ult_small_purchased = purchased_items.select { |item| item.code == 'ult_small' }
    bundles_purchased = ult_small_purchased.count/3

    purchased_items.map do |item|
      if item.code == 'ult_small' && bundles_purchased > 0
        item.price = 0
        bundles_purchased -= 1
      end
     end

     return purchased_items
  end

  def apply_bulk_discounts(purchased_items)
    ult_large_purchased = purchased_items.select { |item| item.code == 'ult_large' }

    if ult_large_purchased.count > 3
      purchased_items.map { |item| item.price = 39.90 if item.code == 'ult_large' }
    end

    return purchased_items
  end

  def get_freebies(purchased_items)
    freebie = SimCard.new('1gb', '1 GB Data-pack', 0)
    ult_mediums_purchased = purchased_items.select { |item| item.code == 'ult_medium' }
    return [freebie] * ult_mediums_purchased.count
  end

  def apply_promo_codes(total, promo_codes)
    if promo_codes.include? 'I<3AMAYSIM'
      total *= 0.9
    end

    return total
  end
end
