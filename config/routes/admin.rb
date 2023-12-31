namespace :admin do
  resources :users, except: [:new, :create] do
    post 'resend_confirmation_email' => 'users#resend_confirmation_email', on: :member
    patch 'unlock' => 'users#unlock', on: :member
  end
  resources :materials
  resources :projects
  resources :regions
  namespace :structure do
    scope ':about_class' do 
      resources :items do
        collection do
          post :reorder
        end
      end
      resources :options do
        collection do
          post :reorder
        end
      end
    end
  end
  root to: "dashboard#index"
end