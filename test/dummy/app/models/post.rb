class Post < ActiveRecord::Base
  include Slug
  
  protected
  
  def default_slug
    "#{title.parameterize}"
  end
  
end
