source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in fixture_record.gemspec.
gemspec

group :development do
  gem "puma"
  gem "sqlite3"
end

group :test do
  gem "minitest-stub_any_instance", "~> 1.0"
end

group :development, :test do
  gem "pry", "~> 0.14.2"
end
