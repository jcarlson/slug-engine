class Permalink < ActiveRecord::Base
  
  belongs_to :content, :polymorphic => true
  before_save :validate_content
  
  validates_presence_of   :slug
  validates_uniqueness_of :slug
  validate :not_system_slug
  
  def to_param
    slug
  end
  
private

  # Validates that the slug is not routable to a controller other than PermalinksController
  def not_system_slug
    begin
      route = Rails.application.routes.recognize_path "/#{slug}"
      errors.add :slug, "is a reserved system route" unless route[:controller] == "permalinks"
    rescue ActionController::RoutingError
      # No route matches, so that's probably good
    end
  end

  def validate_content
    errors.add :content_id, "can't be blank" unless content_id.present?
    errors.add :content_type, "can't be blank" unless content_type.present?
    errors.empty?
  end
  
end
