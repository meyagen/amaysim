The `/src` directory houses all the source files, while `/tests` houses the unit tests.

`/tests/ShoppingCartScenariosSpec.rb` runs all the scenario tests from the exercise specifications.

## Setting up

Install gems ([minitest](https://github.com/seattlerb/minitest) for testing, [rake](https://github.com/ruby/rake) as test runner).
```bash
$ cd /path/to/amaysim
$ bundle install
```

## How to use
Run the interactive ruby shell (irb) and load the `Interface` module.

```bash
$ cd /path/to/amaysim/src
$ irb -r ./interface.rb
```

To use:
```ruby
# create new pricing rules
rules = PricingRules.new

# create new shopping cart
cart = ShoppingCart.new rules

# get sim card products offered
cart.products

# get specific product using its product code
cart.products[:ult_small]

# add a product
cart.add(cart.products[:ult_small])

# add a product and a promo code
cart.add(cart.products[:ult_medium], 'I<3AMAYSIM')

# add only a promo code
cart.add_promo_code('I<3AMAYSIM')

# check applied promo codes
cart.promo_codes

# check purchased items
cart.purchased_items

# check acquired freebies
cart.freebies

# check all items in the cart
cart.items

# get total price
cart.total
```

## Testing

Run all tests from the project root using the Rakefile.
```
$ rake
```
You can also run the individual tests from the terminal.

```bash
$ cd /path/to/amaysim/tests

$ ruby PricingRulesUnitTest.rb
$ ruby ShippingCartScenariosSpec.rb
$ ruby ShoppingCartUnitTest.rb
$ ruby SimCardUnitTest.rb
```
