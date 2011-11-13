class PermalinksController < ApplicationController

  # TODO: Need to figure out how to handle slugs with extensions, e.g., 'foo/bar/baz.jpg'
  def show
    # find permalink, raising error if none found
    @permalink = Permalink.find_by_slug!(params[:slug])
  
    # find content by permalink, raising error if none found
    @content = content_class.find_by_permalink!(@permalink)
    @content_type = @permalink.content_type
    
    # customize view path based on content_type
    prepend_view_path "app/views/#{@content_type.pluralize.underscore}"
    
    # set params[:controller] to match model of content
    params[:controller] = @content_type.pluralize.underscore
    
    # render the appropriate partial for this content, and do it in the layout
    render :partial => partial, :object => decorate(@content), :layout => true

  end

protected

  def content_class
    @permalink.content_type.constantize
  end

  # TODO: Make this an application-extension, not built-in
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
