Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "products#index"


get 'carts/:id' => "carts#show", as: "cart"
delete 'carts/:id' => "carts#destroy"

post 'order_items/:id/add' => "order_items#add_quantity", as: "order_item_add"
post 'order_items/:id/reduce' => "order_items#reduce_quantity", as: "order_item_reduce"
post 'order_items' => "order_items#create"
get 'order_items/:id' => "order_items#show", as: "order_item"
delete 'order_items/:id' => "order_items#destroy"

resources :products
resources :orders

end
