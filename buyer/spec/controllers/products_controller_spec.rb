require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe "products#destroy action" do
    it "shouldn't allow users who didn't create the product to destroy it" do
      product = FactoryBot.create(:product)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: product.id }
      expect(response).to have_http_status(:forbidden)
    end
    it "shouldn't let unauthenticated users destroy a product" do
      product = FactoryBot.create(:product)
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy products" do
      product = FactoryBot.create(:product)
      sign_in product.user
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to root_path
      product = Product.find_by_id(product.id)
      expect(product).to eq nil
    end

    it "should return a 404 message if we cannot find a product with the id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'TRY 1' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "products#update action"do 
     it "shouldn't let users who didn't create the product update it" do
       product = FactoryBot.create(:product)
       user = FactoryBot.create(:user)
       sign_in user
       patch :update, params: { id: product.id, product: { name: 'test' } }
       expect(response).to have_http_status(:forbidden)
    end

     it "shouldn't let unauthenticated users update a product" do
      product = FactoryBot.create(:product)
      patch :update, params: { id: product.id, product: { name: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end    

    it "should allow users to successfully update products" do
      product = FactoryBot.create(:product, name: "Initial Value")
      sign_in product.user

      patch :update, params: { id: product.id, product: { name: 'Changed'}}
      expect(response).to redirect_to root_path
      product.reload
      expect(product.name).to eq "Changed"
    end

    it "should have http 404 error if the product cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user

      patch :update, params: { id: "TRY 2", product: {name: 'Changed'}}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      product = FactoryBot.create(:product, name: "Initial Value")
      sign_in product.user      

      patch :update, params: { id: product.id, product: { name: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      product.reload
      expect(product.name).to eq "Initial Value"
    end
  end
  describe "products#edit action" do
    it "shouldn't let a user who did not create the product edit a product" do
      product = FactoryBot.create(:product)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: product.id }
      expect(response).to have_http_status(:forbidden)
    
    end

    it "shouldn't let unauthenticated users edit a product" do
      product = FactoryBot.create(:product)
      get :edit, params: { id: product.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the product is found" do
      product = FactoryBot.create(:product)
      sign_in product.user

      get :edit, params: { id: product.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the product is not found" do
      user = FactoryBot.create(:user)
      sign_in user

      get :edit, params: { id: 'TRY 3' }
      expect(response).to have_http_status(:not_found)
    end
  end
  describe "products#show action" do
    it "should successfully show the page if the product is found" do
      product = FactoryBot.create(:product)
      get :show, params: { id: product.id }
      expect(response).to have_http_status(:success)
    end
    it "should return a 404 error if the product is not found" do
      get :show, params: { id: 'TRY 4' }
      expect(response).to have_http_status(:not_found)
    end
  end
  describe "products#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
  describe "products#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
       user = FactoryBot.create(:user)
      sign_in user

      get :new
        expect(response).to have_http_status(:success)
    end
  end

  describe "products#create action" do
    it "should require users to be logged in" do
      post :create, params: { product: { name: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new product in our database" do
       user = FactoryBot.create(:user)
       sign_in user
       post :create, params: {
    product: {
      name: 'Hello!',
      picture: fixture_file_upload("/picture.png", 'image/png')
    }
  }
      expect(response).to redirect_to root_path
    
      product = Product.last
      expect(product.name).to eq("Hello!")
      expect(product.user).to eq(user)
    end

      it "should properly deal with validation errors" do
       user = FactoryBot.create(:user)
      sign_in user

      product_count = Product.count
        post :create, params: { product: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(product_count).to eq Product.count
    end
  end
end
