class CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: categories.to_json(only: [ :id, :name ])
  end

  def show
    category = Category.find(params[:id])
    render json: category.to_json(only: [ :id, :name ])
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: category.to_json(only: [ :id, :name ]), status: :created
    else
      render json: category.errors, status: :unprocessable_entity
    end
  end

  def update
    category = Category.find(params[:id])
    if category.update(category_params)
      render json: category.to_json(only: [ :id, :name ])
    else
      render json: category, status: :unprocessable_entity
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    head :no_content
  end

  def products
    products = Product.where(category_id: params[:id])
    render json: products
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
