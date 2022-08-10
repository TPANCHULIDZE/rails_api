class Api::V1::OrdersController < ApplicationController
  include Paginable

  before_action :check_login, only: %i[index show]
  
  def index
    orders = current_user.orders.page(current_page).per(per_page)
    options = get_link_serializer_options('api_v1_orders_path', orders)
    render json: order_serializer(orders, options)
  end

  def show
    order = current_user.orders.find_by(id: params[:id])
    if order 
      render json: order_serializer(order)
    else
      head 404
    end
  end

  def create
    order = current_user.orders.create!
    order.build_placement_with_product_ids_and_quantities(order_params[:product_ids_and_quantities])


    if order.save
      #OrderMailer.send_confirmation(order).deliver
      render json: order_serializer(order), status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(product_ids_and_quantities: [:product_id, :quantity])
  end

  def order_serializer(order, options = {})
    OrderSerializer.new(order, options).serializable_hash.to_json
  end
end
