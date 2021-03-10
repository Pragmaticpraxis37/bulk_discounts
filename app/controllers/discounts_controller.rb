class DiscountsController < ApplicationController
  before_action :find_merchant
  before_action :find_discount, only: [:edit, :update]

  def index
  end

  def new
  end

  def create
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:error] = @discount.errors.full_messages
      render :new
    end
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
  end

  def update
    @discount.update(discount_params)
    if @discount.save
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash[:error] = @discount.errors.full_messages
      render :edit
    end
  end

  def destroy
    Discount.destroy(params[:id])
    redirect_to merchant_discounts_path(@merchant)
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_discount
    @discount = Discount.find(params[:id])
  end


  def discount_params
    params.permit(:percent_discount, :quantity)
  end
end
