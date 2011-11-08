class Post < ActiveRecord::Base
  include HasPermalink
  
  protected
  
  def default_slug
    "#{title.parameterize}"
  end
  
end
