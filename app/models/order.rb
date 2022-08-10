class Order < ApplicationRecord
  validates_with EnoughProductsValidator

  before_validation :set_total!

  belongs_to :user

  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true

  private

  def build_placement_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      placements = Placements.new(
        product_id: product_id_and_quantity[:product_id],
        quantity: product_id_and_quantity[:quantity]
      )

      yield placements if block_given?
    end
  end

  def set_total!
    self.total = self.placements.map{ |placement| placement.product.price * placement.quantity }.sum
  end
end
