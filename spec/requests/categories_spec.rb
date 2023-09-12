require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) do
    User.create(name: 'John Doe', email: 'john@example.com', password: 'password123',
                password_confirmation: 'password123')
  end

  before do
    sign_in user
  end

  describe 'POST #create' do
    it 'creates a new category' do
      expect do
        post :create,
             params: { category: { name: 'New Category',
                                   icon: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'icon.png'),
                                                             'image/png') } }
      end.to change(Category, :count).by(1)

      expect(response).to redirect_to(categories_path)
      expect(flash[:notice]).to eq('Category was successfully created.')
    end

    it 'renders new template if category creation fails' do
      expect do
        post :create,
             params: { category: { name: '',
                                   icon: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'icon.png'),
                                                             'image/png') } }
      end.not_to change(Category, :count)

      expect(response).to render_template(:new)
    end
  end
end
