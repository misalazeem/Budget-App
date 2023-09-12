# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Category Show Page', type: :feature do
  let!(:user) { User.create(name: 'user', email: 'user@example.com', password: 'password') }

  before do
    login_as(user, scope: :user)
    groceries_category = Category.create(name: 'Groceries', icon: '/uploads/icon.png', user:)
    purchase1 = Purchase.create(name: 'Milk', amount: 2.99, user:)
    purchase2 = Purchase.create(name: 'Bread', amount: 1.99, user:)
    PurchaseCategory.create(purchase: purchase1, category: groceries_category)
    PurchaseCategory.create(purchase: purchase2, category: groceries_category)
    visit category_path(groceries_category)
  end

  scenario 'displays category details and purchases' do
    expect(page).to have_content('Groceries')
    expect(page).to have_content('Total Amount: 4.98')

    expect(page).to have_content('Milk - Amount: 2.99')
    expect(page).to have_content('Bread - Amount: 1.99')
  end

  scenario 'navigates back to categories index' do
    click_on 'Back'
    expect(page).to have_current_path(categories_path)
  end

  scenario 'allows adding a new purchase' do
    groceries_category = Category.find_by(name: 'Groceries') # Retrieve the category
    click_on 'Add a New Purchase'
    expect(page).to have_current_path(new_category_purchase_path(groceries_category))
  end

  scenario 'allows signing out' do
    click_on 'Sign Out'
    expect(page).to have_content('Sign in')
  end
end
