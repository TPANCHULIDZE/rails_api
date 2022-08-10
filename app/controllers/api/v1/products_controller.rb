class Api::V1::ProductsController < ApplicationController
  include Paginable

  before_action :set_product, only: %i[show update destroy]
  before_action :check_login, only: %i[create]
  before_action :check_owner, only: %i[update destroy]

  def index
    @products = Product.includes(:user).page(current_page).per(per_page).search(params)
    render json: products_serializer
  end

  def show
    render json: product_serializer
  end

  def create
    @product = current_user.products.new(product_params)

    if @product.save
      render json: product_serializer, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: product_serializer, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head 204
  end

  private

  def product_serializer
    options = { include: [:user] }
    ProductSerializer.new(@product, options).serializable_hash.to_json
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def set_product
    @product = Product.find_by(id: params[:id])
  end

  def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end

  def products_serializer
    options = get_link_serializer_options('api_v1_products_path', @products)
    options[:include] = [:user]
    ProductSerializer.new(@products, options).serializable_hash.to_json
  end

end
