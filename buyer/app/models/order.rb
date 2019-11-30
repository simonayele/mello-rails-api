class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  before_save :update_total
  

  def calculate_total
    self.order_items.collect { |item| item.product.price * item.quantity }.sum
  end

  private

 

  def update_total
    self.total_price = calculate_total
  end
end

