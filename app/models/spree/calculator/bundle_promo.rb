require_dependency 'spree/calculator'

module Spree
  class Calculator::BundlePromo < Calculator
    preference :promotion_name, :string, default: 'BundlePromotion'
    preference :discount_per_bundle, :decimal, default: 5.00

    def self.description
      'Bundle Promotion'
    end

    def compute(order)
      throw 'Invalid param encountered (Calculator::BundlePromo#compute)' unless order.is_a?(Spree::Order)
      
      bundle_promo = order.promotions.select{|p| p.name == preferred_promotion_name}[0]
      return 0 unless bundle_promo
      
      bundle_product_counts = bundle_promo.products.map{|p| product_count_in_order(order, p.id)}
      preferred_discount_per_bundle * bundle_product_counts.min
    end

    def product_count_in_order(order, product_id)
      order.line_items.each do |item|
        return item.quantity if item.product.id == product_id.to_i
      end
      0
    end
  end
end
