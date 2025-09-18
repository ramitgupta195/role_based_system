Rails.application.routes.draw do
  devise_for :users,
             defaults: { format: :json },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations"
             }


      # Super Admin can manage Admins & Users
      resources :admins, only: [ :index, :create, :update, :destroy ]
      resources :users, only: [ :index, :create, :update, :destroy ]

      # Normal User can manage their own profile
      resource :profile, only: [ :show, :update ]
end
