# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show destroy]

  def new
    @category = current_user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      handle_uploaded_icon_file if category_params[:icon].present?
      redirect_to categories_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully destroyed.'
  end

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @transactions = @category.purchases
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :icon)
  end

  def handle_uploaded_icon_file
    uploaded_file = category_params[:icon]
    file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)

    File.open(file_path, 'wb') do |file|
      file.write(uploaded_file.read)
    end

    @category.update(icon: File.join('/uploads', uploaded_file.original_filename))
  end
end
