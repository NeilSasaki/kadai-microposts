Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create] do
    member do
      get :followings
      #member の get :followings に対応して /users/:id/followings という URL が生成される
      get :followers
      #member の get :followers に対応して /users/:id/followers という URL が生成される
      #課題の要件としてlikesアクションが求められているので、users/:id/likesを生成する
      get :likes
      #課題の要件としてlikesアクションが求められているので、users/:id/likesを生成する
      # get :famousfor 今回は特に使わないが、将来使うかもしれない
      #memberのget :famousforに対してusers/:id/famousforというURLが生成される
    end
  end

  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy] #フォロー、アンフォローのためのルーティング
  resources :favorites, only: [:create, :destroy] #お気に入り登録解除のためのルーティング
  
end
