require 'rails_helper'

RSpec.describe UserCreator, type: :service do
  context 'cart has an existing user' do
    let(:cart) { create(:cart) }
    it 'returns cart with an user' do
      expect(UserCreator.call(cart, {})).to eq(cart.user)
    end
  end
  
  context 'cart has not an existing user' do
    let(:cart_without_user) { create(:cart, user: nil) }
    it 'creates a guest user' do
      expect(UserCreator.call(cart_without_user, {}).guest).to eq(true)
    end
  end
end
