class Dispatcher
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers

  attr_reader :env

  def dispatch
    # find permalink, raising error if none found
    if permalink
      # mutate env to include params for delegate route
      params.merge! content_route

      # setup and delegate to the matched route
      delegate.action(content_route[:action]).call(env)
    else
      # no slug matched, abstain from handling request
      [404, {"X-Cascade" => "pass"}, ["no such slug exists"]]
    end

  end

  def self.call(env)
    new(env).dispatch
  end

private

  def content
    content_class.find_by_permalink!(permalink)
  end

  def content_class
    @content_class ||= @permalink.content_type.camelize.constantize
  end

  def content_path
    polymorphic_path(content)
  end

  def content_route
    Rails.application.routes.recognize_path(content_path, :method =>:get)
  end

  def delegate
    @delegate ||= [content_route[:controller], "Controller"].join.camelize.constantize
  end

  def initialize(env)
    @env = env
  end

  def params
    env["action_dispatch.request.path_parameters"]
  end

  def permalink
    @permalink ||= Permalink.find_by_slug(slug)
  end

  def slug
    params[:slug]
  end

end