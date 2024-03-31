# frozen_string_literal: true

module FixtureRecord::Generators
	class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def create_initializer
      application(nil, env: :development) do
        <<-TXT
          # By default, fixture_record will only inject itself in the development environment.
          # If you want it available in `test` or `production` (or other environments), please add
          # this require line to those environment ruby files. Alternatively, if you want it to
          # always be loaded, you can relocate the generated `fixture_record/initializer.rb` to
          # `app/config/initializers/fixture_record.rb` or require this file in  `config/application.rb`.
          require Rails.root.join('fixture_record', 'initializer.rb')\n
        TXT
      end
			template "initializer.rb", Rails.root.join("fixture_record/initializer.rb")
		end
  end
end
