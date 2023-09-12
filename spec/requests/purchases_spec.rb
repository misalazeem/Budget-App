# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do
  let(:user) do
    User.create(name: 'John Doe', email: 'john@example.com', password: 'password123',
                password_confirmation: 'password123')
  end
  let(:category) { Category.create(name: 'Groceries', icon: 'icon.png', user:) }

  before do
    sign_in user
  end

  describe 'GET #show' do
    it 'assigns the requested purchase to @purchase' do
      purchase = Purchase.create(name: 'Milk', amount: 2.99, user:)
      PurchaseCategory.create(purchase_id: purchase.id, category_id: category.id)
      get :show, params: { category_id: category.id, id: purchase.id }

      expect(assigns(:purchase)).to eq(purchase)
    end

    it 'renders the show template' do
      purchase = Purchase.create(name: 'Milk', amount: 2.99, user:)
      get :show, params: { category_id: category.id, id: purchase.id }

      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new purchase to @purchase' do
      get :new, params: { category_id: category.id }
      expect(assigns(:purchase)).to be_a_new(Purchase)
    end

    it 'assigns the current user\'s categories to @categories' do
      get :new, params: { category_id: category.id }
      expect(assigns(:categories)).to eq(user.categories)
    end

    it 'renders the new template' do
      get :new, params: { category_id: category.id }
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new purchase' do
        expect do
          post :create,
               params: { category_id: category.id,
                         purchase: { name: 'Bread', amount: 1.99, category_ids: [category.id] } }
        end.to change(Purchase, :count).by(1)
      end

      it 'creates a new purchase category' do
        expect do
          post :create,
               params: { category_id: category.id,
                         purchase: { name: 'Bread', amount: 1.99, category_ids: [category.id] } }
        end.to change(PurchaseCategory, :count).by(2)
      end

      it 'sets a notice message' do
        post :create,
             params: { category_id: category.id,
                       purchase: { name: 'Bread', amount: 1.99, category_ids: [category.id] } }
        expect(flash[:notice]).to eq('Purchase was successfully created.')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new purchase' do
        expect do
          post :create,
               params: { category_id: category.id, purchase: { name: '', amount: 1.99, category_ids: [category.id] } }
        end.not_to change(Purchase, :count)
      end

      it 'renders the new template' do
        post :create,
             params: { category_id: category.id, purchase: { name: '', amount: 1.99, category_ids: [category.id] } }
        expect(response).to render_template(:new)
      end
    end
  end
end
