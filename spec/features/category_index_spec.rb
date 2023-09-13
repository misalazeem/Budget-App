require 'rails_helper'

RSpec.feature 'Category Index Page', type: :feature do
  let!(:user) { User.create(name: 'user', email: 'user@example.com', password: 'password') }
  let!(:groceries_category) { Category.create(name: 'Groceries', icon: '/uploads/icon.png', user:) }
  let!(:electronics_category) { Category.create(name: 'Electronics', icon: '/uploads/icon.png', user:) }

  before do
    login_as(user, scope: :user)
    visit categories_path
  end

  scenario 'displays the categories' do
    expect(page).to have_text('Categories')
    expect(page).to have_link('Sign Out')

    expect(page).to have_selector('.category-item', count: 2)

    within('.category-item', match: :first) do
      expect(page).to have_css('h2', text: 'Groceries')
      expect(page).to have_text('Total Amount:')
    end
  end

  scenario 'allows adding a new category' do
    expect(page).to have_link('Add a New Category')
    click_link('Add a New Category')
    expect(page).to have_current_path(new_category_path)
  end

  scenario 'allows navigating back to the home page' do
    click_link('Back')
    expect(page).to have_current_path(root_path)
  end

  scenario 'allows signing out' do
    click_link('Sign Out')
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('Sign in')
  end
end
