class PurchasesController < ApplicationController
  def create
    return render json: { errors: [{ message: 'Gateway not supported!' }] },
      status: :unprocessable_entity unless valid_gateway

    @cart = Cart.find_by(id: purchase_params[:cart_id])

    return render json: { errors: [{ message: 'Cart not found!' }] },
     status: :unprocessable_entity unless @cart

    @user = UserCreator.call(@cart, purchase_params)

    return render json: { errors: @user.errors.map(&:full_message).map { |message| { message: message } } },
     status: :unprocessable_entity unless @user.valid?

    @order = OrderCreator.call(@user, address_params)
    CartOrderItens.call(@cart, @order)
    @order.save

    return render json: { errors: @order.errors.map(&:full_message).map { |message| { message: message } } },
     status: :unprocessable_entity unless @order.valid?

    return render json: { status: :success, order: { id: @order.id } }, status: :ok
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

  def valid_gateway
    permited_gateways = ['paypal', 'stripe']
    permited_gateways.include?(purchase_params[:gateway])
  end
end
