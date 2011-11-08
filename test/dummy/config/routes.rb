Dummy::Application.routes.draw do
  resources :users
  resources :posts
  mount HasPermalink::Engine => "/"
end
