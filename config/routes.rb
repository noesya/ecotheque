Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  authenticate :user, -> (user) { user.superadmin? } do
    mount GoodJob::Engine => 'good_job'
  end

  post 'webhooks/helloasso' => 'webhooks#helloasso', as: :helloasso_webhook

  draw 'admin'

  # Tunnel d'abo
  get 'le-lab/comment-nous-rejoindre' => 'offers#index', as: :offers
  get 'le-lab/comment-nous-rejoindre/nouvel-abonnement'               => 'subscriptions#new', as: :new_subscription
  get 'le-lab/comment-nous-rejoindre/nouvel-abonnement/recapitulatif' => 'subscriptions#summary', as: :summary_subscription
  post 'le-lab/comment-nous-rejoindre/nouvel-abonnement/paiement'     => 'subscriptions#payment', as: :payment_subscription
  get 'le-lab/comment-nous-rejoindre/nouvel-abonnement/retour'        => 'subscriptions#helloasso_callback', as: :helloasso_callback_subscription
  get 'le-lab/comment-nous-rejoindre/nouvel-abonnement/verification'  => 'subscriptions#verification', as: :verification_subscription
  post 'le-lab/comment-nous-rejoindre/nouvel-abonnement/verification' => 'subscriptions#async_verification'
  get 'le-lab/comment-nous-rejoindre/nouvel-abonnement/confirmation'  => 'subscriptions#confirmation', as: :confirmation_subscription

  get 'le-lab/les-membres' => 'members#index', as: :members

  get 'communaute' => 'users#index', as: :users
  get 'communaute/:id' => 'users#show', as: :user

  scope 'mon-compte' do
    get 'suivi' => 'favorites#index', as: :favorites
    put 'suivi' => 'favorites#create'
    delete 'suivi' => 'favorites#destroy'
    resources :comments, path: 'commentaires', as: :user_comments
  end

  get 'recherche' => 'search#show', as: :search

  scope "(:region_slug)", constraints: lambda { |request|
      region_slug = request.params[:region_slug]
      region_slug.blank? || Region.where(slug: region_slug).exists?
    } do
    resources :actors, path: 'ecosysteme', only: [:index, :show] do
      collection do
        get 'carte' => 'actors#index', as: :map, mode: 'map'
        get 'glossaire' => 'actors#options', as: :options
        get ':item_slug/:option_slug' => 'actors#option', as: :option
      end
    end
    resources :materials, path: 'materiaux', only: [:index, :show] do
      collection do
        get 'glossaire' => 'materials#options', as: :options
        get ':item_slug/:option_slug' => 'materials#option', as: :option
      end
    end
    resources :projects, path: 'projets', only: [:index, :show] do
      collection do
        get 'glossaire' => 'projects#options', as: :options
        get ':item_slug/:option_slug' => 'projects#option', as: :option
      end
    end
    resources :technics, path: 'techniques', only: [:index, :show] do
      collection do
        get 'glossaire' => 'technics#options', as: :options
        get ':item_slug/:option_slug' => 'technics#option', as: :option
      end
    end
  end
  get 'regions' => 'regions#index', as: :regions
  get '/:id' => 'regions#show', as: :region, constraints: lambda { |request|
    region_slug = request.params[:id]
    Region.where(slug: region_slug).exists?
  }

  match '*path', via: :all, to: 'pages#show', constraints: lambda { |req|
    Page.find_by(path: req.path[1..-1]).present?
  }

  get '/media/:signed_id/:filename_with_transformations' => 'media#show', as: :medium

  root to: 'home#index'
end
