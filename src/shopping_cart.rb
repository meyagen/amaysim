class ShoppingCart
  attr_accessor :purchased_items, :promo_codes, :freebies, :products

  def initialize(pricing_rules)
    @rules = pricing_rules
    @total_purchase = 0

    @freebies = []
    @promo_codes = []
    @purchased_items = []

    @valid_promo_codes = ['I<3AMAYSIM']

    @products = {
      ult_small: SimCard.new('ult_small', 'Unlimited 1GB', 24.90),
      ult_medium: SimCard.new('ult_medium', 'Unlimited 2GB', 29.90),
      ult_large: SimCard.new('ult_large', 'Unlimited 5GB', 44.90),
      gb: SimCard.new('1gb', '1 GB Data-pack', 9.90),
    }
  end

  def add(item, promo_code = nil)
    @purchased_items << item
    self.add_promo_code(promo_code)
    compute_order
  end

  def add_promo_code(promo_code)
    valid_code = @valid_promo_codes.include? promo_code

    unless !valid_code || (@promo_codes.include? promo_code)
      @promo_codes << promo_code
    end

    compute_order
  end

  def items
    compute_order
    @purchased_items + @freebies
  end

  def total
    compute_order
  end

  private

  # re-compute order on every function call
  # to ensure that all variables are updated correctly
  # when they are called
  def compute_order
    @freebies = @rules.get_freebies(@purchased_items)
    discounted_purchased_items = @rules.apply_pricing_rules(@purchased_items)

    @total_purchase = discounted_purchased_items.map(&:price).reduce(0, :+)
    @total_purchase = @rules.apply_promo_codes(@total_purchase, @promo_codes)
    @total_purchase = @total_purchase.round(2)
  end

end