namespace :admin do
  resources :users, except: [:new, :create] do
    post 'resend_confirmation_email' => 'users#resend_confirmation_email', on: :member
    patch 'unlock' => 'users#unlock', on: :member
  end
  resources :actors
  resources :comments, only: :index do
    collection do
      get :pending
    end
    member do
      post :approve
      post :reject
    end
  end
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
  get 'logs' => 'logs#index', as: :logs
  namespace :transparency do
    resources :years do
      resources :revenues, except: :index
      resources :costs, except: :index
    end
  end
  resources :mailer_contents, except: [:new, :create, :destroy]
  get 'banner' => 'banner#edit'
  patch 'banner' => 'banner#update'
  get 'analytics' => 'analytics#index'
  root to: "dashboard#index"
end