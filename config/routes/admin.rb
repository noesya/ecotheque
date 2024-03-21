namespace :admin do
  resources :users, except: [:new, :create] do
    post 'resend_confirmation_email' => 'users#resend_confirmation_email', on: :member
    patch 'unlock' => 'users#unlock', on: :member
  end
  resources :actors
  resources :comments
  resources :materials
  resources :projects
  resources :technics
  namespace :projects do 
    resources :criterions do
      collection do
        post :reorder
      end
    end
  end
  resources :regions
  resources :pages do 
    resources :blocks, controller: 'pages/blocks', except: [:index, :show] do
      collection do
        post :reorder
      end
    end
    collection do
      post :reorder
    end
    member do
        get :children
    end
  end
  resources :definitions
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