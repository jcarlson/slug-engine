Slug::Engine.routes.draw do
  
  get '*slug' => 'permalinks#show', :as => :permalink
  
end
