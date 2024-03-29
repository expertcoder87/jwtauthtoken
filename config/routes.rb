Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
    namespace :api, defaults: { format: :json } do
	    namespace :v1 do
	      devise_scope :user do
	        post 'signup' => 'registrations#create'
	        post 'signin' => 'sessions#create'
	      end
	    end
  	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
