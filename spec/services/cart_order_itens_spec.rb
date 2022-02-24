require 'rails_helper'

RSpec.describe CartOrderItens, type: :service do
  context 'creates order to add itens to cart' do
    let(:sale) { create(:sale) }
    let(:item) { create(:cart_item, sale: sale, quantity: 2) }
    let(:order) { create(:order, user: item.cart.user) }
    it 'adds itens to cart with existing order' do
        expect { CartOrderItens.call(item.cart, order) }.to change(OrderLineItem, :count).by(item.quantity)
    end
  end
end
