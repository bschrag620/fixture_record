require_relative "lib/fixture_record/version"

Gem::Specification.new do |spec|
  spec.name        = "fixture_record"
  spec.version     = FixtureRecord::VERSION
  spec.authors     = ["Brad Schrag"]
  spec.email       = ["brad.schrag@gmail.com"]
  spec.homepage    = "https://github.com/bschrag620/fixture_record"
  spec.summary     = "Summary of FixtureRecord."
  spec.description = "Description of FixtureRecord."
  spec.license     = "MIT"

  spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bschrag620/fixture_record"
  spec.metadata["changelog_uri"] = "https://github.com/bschrag620/fixture_record"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.2"
end
