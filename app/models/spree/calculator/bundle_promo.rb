require_dependency 'spree/calculator'

module Spree
  class Calculator::BundlePromo < Calculator
    preference :product_a_id, :int, default: 1
    preference :product_b_id, :int, default: 2
    preference :discount_per_bundle, :decimal, default: 5.00

    def self.description
      'Bundle Promotion'
    end

    def compute(order)
      throw 'Invalid param encountered (Calculator::BundlePromo#compute)' unless order.is_a?(Spree::Order)
      product_a_cnt = product_count_in_order(order, preferred_product_a_id)
      product_b_cnt = product_count_in_order(order, preferred_product_b_id)
      preferred_discount_per_bundle * [product_a_cnt, product_b_cnt].min
    end

    def product_count_in_order(order, product_id)
      order.line_items.each do |item|
        return item.quantity if item.product.id == product_id.to_i
      end
      0
    end
  end
end

