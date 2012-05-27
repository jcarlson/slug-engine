Slug::Engine.routes.draw do
  
  get '*slug' => Dispatcher, :as => :permalink

end
