class Permalink < ActiveRecord::Base
  
  belongs_to :content, :polymorphic => true
  before_save :validate_content
  
  validates_presence_of   :slug
  validates_uniqueness_of :slug
  validate :not_system_slug
  
private

  # Validates that the slug is not routable to a controller other than PermalinksController
  def not_system_slug
    route = Rails.application.routes.recognize_path "/#{slug}"
    errors.add :slug, "is a reserved system route" unless route[:controller] == "permalinks"
  end

  def validate_content
    errors.add :content_id, "can't be blank" unless content_id.present?
    errors.add :content_type, "can't be blank" unless content_type.present?
    errors.empty?
  end
  
end
