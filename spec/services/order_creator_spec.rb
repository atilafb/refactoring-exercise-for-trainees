require 'rails_helper'

RSpec.describe OrderCreator, type: :service do
  context 'create order to existing user' do
    let(:user) { create(:user) }
    it 'returns order' do
      expect(OrderCreator.call(user, {}).attributes).to include({
        "user_id" => 1,
        "first_name" => "John",
        "last_name" => "Doe",
        "address_1" => nil,
        "address_2" => nil,
        "city" => nil,
        "state" => nil,
        "country" => nil,
        "zip" => nil
 })
    end
  end
end
