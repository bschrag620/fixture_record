# frozen_string_literal: true

module FixtureRecord::Generators
	class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def create_initializer
			template "initializer.rb", Rails.root.join("config/initializers/fixture_record.rb")
		end
  end
end
