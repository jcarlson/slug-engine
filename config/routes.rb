HasPermalink::Engine.routes.draw do
  
  get '*slug' => 'permalinks#show'
  
end
