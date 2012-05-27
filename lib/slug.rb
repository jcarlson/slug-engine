require "slug/engine"

module Slug
  extend ActiveSupport::Concern
  
  included do
    # setup polymorphic association
    has_one :permalink, :as => :content, :dependent => :destroy, :autosave => true

    # allows forms to accept values for permalink
    accepts_nested_attributes_for :permalink

    # allows alternative access to slug (although validation errors will still be on 'permalink.slug')
    delegate :slug, :slug=, :to => :permalink

    # add validation callbacks
    before_validation :set_default_slug

    # This little syntactic sugar causes permalink to be created lazily precisely
    # the first time it is accessed. This is necessary because we delegate :slug
    # to :permalink, and if permalink is nil, things get hairy.
    redefine_method(:permalink) do |*args|
      association(:permalink).reader(*args) || build_permalink(*args)
    end

    # Setup a 'permalink' scope so model classes can find by permalink
    # find_by_permalink doesn't use this, but it may be useful elsewhere
    scope :permalink, lambda { |permalink| where(:id => permalink.content_id) }

  end

  module ClassMethods

    # Finder returning the matching content for a given permalink, or nil if
    # none found. Notably, the content_type of the given permalink must match
    # the target model's class
    def find_by_permalink(permalink)
      find_by_permalink!(permalink)
    rescue
      nil
    end

    # Finder returning the matching content for a given permalink. Raises an
    # ActiveRecord::RecordNotFound error if no match is found or if the 
    # content_type of the given permalink must match the target model's class
    def find_by_permalink!(permalink)
      result = scoped_by_permalink(permalink).first
      raise ActiveRecord::RecordNotFound.new "Could not find Content for Permalink id=#{permalink.id}" if result.nil?
      result
    end

  protected

    # Default scope for returning the matching content for a given permalink.
    # Model classes may override this method to extend the scope query, for
    # example, to restrict content found by permalink by additional parameters.
    def scoped_by_permalink(permalink)
      # scoped_by_id is a 'magic' scope created by missing_method
      scoped_by_id(permalink.content_id)
    end

  end

  module InstanceMethods

  protected

    # provide a suitable default slug value
    def default_slug
      nil
    end

    # set default_slug on permalink before validation
    def set_default_slug
      permalink.slug = default_slug unless permalink.slug.present?
    end

  end
end
