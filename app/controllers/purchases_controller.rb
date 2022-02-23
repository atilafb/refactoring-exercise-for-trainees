class PurchasesController < ApplicationController
  def create
    if purchase_params[:gateway] == 'paypal' || purchase_params[:gateway] == 'stripe'
      cart = find_cart

      unless cart
        return render json: { errors: [{ message: 'Cart not found!' }] }, status: :unprocessable_entity
      end

      user = UserCreator.call(cart, purchase_params)

      if user.valid?
        order = OrderCreator.call(user, address_params)
        CartOrderItens.call(cart, order)
        order.save

        if order.valid?
          return render json: { status: :success, order: { id: order.id } }, status: :ok
        else
          return render json: { errors: order.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity
        end
      else
        return render json: { errors: user.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity
      end
    else
      render json: { errors: [{ message: 'Gateway not supported!' }] }, status: :unprocessable_entity
    end
  end

  private

  def purchase_params
    params.permit(
      :gateway,
      :cart_id,
      user: %i[email first_name last_name],
      address: %i[address_1 address_2 city state country zip]
    )
  end

  def address_params
    purchase_params[:address] || {}
  end

  def find_cart
    @cart = Cart.find_by(id: purchase_params[:cart_id])
  end
end
