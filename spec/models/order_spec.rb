require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:items).class_name('OrderLineItem').dependent(:destroy) }

  describe '#subtotal_cents' do
    subject { order.subtotal_cents }

    context 'when there are items' do
      let(:sale1) { build_stubbed(:sale, unit_price_cents: 100) }
      let(:sale2) { build_stubbed(:sale, unit_price_cents: 100) }
      let(:item1) do
        build_stubbed(:order_line_item, sale: sale1, unit_price_cents: sale1.unit_price_cents, paid_price_cents: 1)
      end
      let(:item2) do
        build_stubbed(:order_line_item, sale: sale2, unit_price_cents: sale2.unit_price_cents, paid_price_cents: 1)
      end

      let(:order) { build_stubbed(:order) }

      before do
        allow(order).to receive(:items).and_return([item1, item2])
      end

      it { is_expected.to eq 200 }
    end

    context 'when there are no items' do
      let(:order) { build_stubbed(:order) }

      before do
        allow(order).to receive(:items).and_return([])
      end

      it { is_expected.to be_zero }
    end
  end

  describe '#total_cents' do
    subject { order.total_cents }

    context 'when there are items' do
      let(:sale1) { build_stubbed(:sale, unit_price_cents: 100) }
      let(:sale2) { build_stubbed(:sale, unit_price_cents: 100) }
      let(:item1) do
        build_stubbed(:order_line_item, sale: sale1, unit_price_cents: 1, paid_price_cents: sale1.unit_price_cents)
      end
      let(:item2) do
        build_stubbed(:order_line_item, sale: sale2, unit_price_cents: 1, paid_price_cents: sale2.unit_price_cents)
      end

      let(:order) { build_stubbed(:order) }

      before do
        allow(order).to receive(:items).and_return([item1, item2])
      end

      it { is_expected.to eq 200 }
    end

    context 'when there are no items' do
      let(:order) { build_stubbed(:order) }

      before do
        allow(order).to receive(:items).and_return([])
      end

      it { is_expected.to be_zero }
    end
  end
end
