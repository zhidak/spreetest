require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class CustomFreeShipping < ShippingCalculator
      preference :min_total_for_free_shipping, :decimal, default: 150
      preference :flat_rate, :decimal, default: 10.00

      def self.description
        "Free Shipping Over Certain Amount"
      end

      def compute_package(package)
        total(package.contents) >= preferred_min_total_for_free_shipping ? 0 : preferred_flat_rate
      end
    end
  end
end

