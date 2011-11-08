class PermalinksController < ApplicationController

  # TODO: Need to figure out how to handle slugs with extensions, e.g., 'foo/bar/baz.jpg'
  def show
    # find permalink, raising (404) error if none found
    @permalink = Permalink.find_by_slug!(params[:slug])
    
    # find content by permalink, raising (404) if none found
    @content = content_class.find_by_permalink!(@permalink)
    @content_type = @permalink.content_type
    
    # customize view path based on content_type
    prepend_view_path "app/views/#{@content_type.pluralize.underscore}"
    
    # set params[:controller] to model of content
    params[:controller] = @content_type.pluralize.underscore
    
    # render the appropriate partial for this content, and do it in the layout
    render :partial => partial, :object => decorate(@content), :layout => true

  end

protected

  def content_class
    Module.const_get @permalink.content_type
  end

  def decorate(content)
    decorated = begin
      Module.const_get("#{@content_type}Decorator").decorate(content)
    rescue NameError
      content
    end
    decorated
  end
  
  def partial
    # We're going to have to make a guess about this...
    # TODO: Is there some way to still defer to the partial renderer to determine the partial to use?
    "#{@content_type.downcase.pluralize}/#{@content_type.downcase}"
  end

end
