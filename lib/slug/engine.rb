module Slug
  class Engine < Rails::Engine
    
    # Use the SlugFilter to avoid processing slugs that do not exist
    config.middleware.use Slug::Filter
    
  end
end
