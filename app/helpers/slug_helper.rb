module SlugHelper
  
  def slug_path(content)
    if content.respond_to?(:slug)
      slug_engine.permalink_path(content.slug)
    else
      polymorphic_path(content)
    end
  end
  
  def slug_url(content)
    if content.respond_to?(:slug)
      slug_engine.permalink_url(content.slug)
    else
      polymorphic_url(content)
    end
  end
  
end