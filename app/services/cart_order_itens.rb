class CartOrderItens < ApplicationService
  def initialize(cart, order)
    @cart = cart
    @order = order
  end

  def call
    @cart.items.each do |item|
      item.quantity.times do
        @order.items << ItemOrderCreator.call(@order, item)
      end
    end
  end
end
