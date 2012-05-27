$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "slug/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "slug-engine"
  s.version     = Slug::VERSION
  s.authors     = ["Jarrod Carlson"]
  s.email       = ["jarrod.carlson@gmail.com"]
  s.homepage    = "https://github.com/jcarlson/slug-engine"
  s.summary     = "Rails Engine for processing and rendering permalinks for content"
  s.description = "Rails Engine for permalinks"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.1.1"

  s.add_development_dependency "sqlite3"
end
