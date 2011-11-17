module Slug

  # This middleware is necessary so that the engine can abstain from processing
  # requests where no such slug exists. If this behavior were done in a
  # controller, Rails would heavily mutate the request object and no additional
  # controllers would have much luck processing the request. Specifically, the
  # named parameters for the route are cached on the request, and downstream
  # controllers would get the wrong params hash.

  class Filter
    
    def initialize(app)
      @app = app
    end
  
    def call(env)
      # if a matching slug exists in the database, allow engine to process it
      if Permalink.where('slug = ?', slug(env)).exists?
        # slug found, allow request to continue to controller
        @app.call(env)
      else
        # no slug matched, abstain from handling request
        [404, {"X-Cascade" => "pass"}, ["no such slug exists"]]
      end
    end

    # Extract the :slug value from the raw request
    def slug(env)
      slug = env['PATH_INFO']
      slug = slug.slice(1..-1) if slug[0] == 47 # has a leading '/'
      slug
    end
    
  end
end