require_relative "lib/fixture_record/version"

Gem::Specification.new do |spec|
  spec.name        = "fixture_record"
  spec.version     = FixtureRecord::VERSION
  spec.authors     = ["Brad Schrag"]
  spec.email       = ["brad.schrag@gmail.com"]
  spec.homepage    = "https://github.com/bschrag620/fixture_record"
  spec.summary     = "Helper library for generating test fixtures."
  spec.description = "Helper library for generating test fixtures for existing records and their associated associations and relationships."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bschrag620/fixture_record"
  spec.metadata["changelog_uri"] = "https://github.com/bschrag620/fixture_record"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6"
end
