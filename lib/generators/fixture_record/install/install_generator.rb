# frozen_string_literal: true

module FixtureRecord::Generators
	class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def create_fixture_record_schema
      # TODO - implement the generator
    end

    def create_initializer
      application(nil, env: :development) do
        "require Rails.root.join('fixture_record', 'initializer.rb')\n"
      end
			template "initializer.rb", Rails.root.join("fixture_record/initializer.rb")
		end
  end
end
