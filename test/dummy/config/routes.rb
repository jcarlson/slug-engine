Dummy::Application.routes.draw do
  resources :posts
  mount HasPermalink::Engine => "/"
  resources :users
end
