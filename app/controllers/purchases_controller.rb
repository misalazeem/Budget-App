class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  def index
    @purchases = Purchase.all
  end

  def show
    @purchase = Purchase.find(params[:id])
  end

  def new
    @category = Category.find(params[:category_id])
    @categories = current_user.categories
    @purchase = Purchase.new
  end

  def create
    category_ids = Array(purchase_params.delete(:category_ids))
    name = params[:purchase][:name]
    amount = params[:purchase][:amount]
    current_category = Category.find(params[:category_id])
  
    @purchase = Purchase.new(name: name, amount: amount, user: current_user)
  
    if @purchase.save
      PurchaseCategory.create(purchase_id: @purchase.id, category_id: current_category.id)
  
      category_ids.each do |category_id|
        next if category_id.blank?
        begin
          PurchaseCategory.create(purchase_id: @purchase.id, category_id: category_id)
        rescue ActiveRecord::RecordNotFound
        end
      end
      redirect_to category_path(current_category), notice: 'Purchase was successfully created.'
    else
      @categories = current_user.categories
      render :new
    end
  end
  
  def edit
  end

  def update
    if @purchase.update(purchase_params)
      @purchase.category_ids = params[:purchase][:category_ids]
      redirect_to @purchase, notice: 'Purchase was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @purchase.destroy
    redirect_to purchases_url, notice: 'Purchase was successfully destroyed.'
  end

  private

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  def purchase_params
    params.require(:purchase).permit(:name, :amount, :user_id, category_ids: [])
  end
end
