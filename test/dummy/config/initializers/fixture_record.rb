if Rails.env.development? || Rails.env.test?
  FixtureRecord.configure do |config|
    # To customize how fixtures are named, provide a class the responds to #call or a Proc.
    # The name handler object will receive the record and should return a String
    # config.name_handler = FixtureRecord::Naming::Base

    # base_path represents the base folder that FixureRecord will search for existing yml files
    # to merge new fixture data with and it serves as the path for where FixtureRecord will output the
    # new yml files as needed. To override, provide a String, Pathname object, or Proc/ambda to be evaluated at runtime
    # config.base_path = -> { Rails.root.join('test/fixtures') }

    # Create and register custom sanitizers to format, sanitiize, obfuscate, etc. the data before it is
    # turned into a test fixture. Regex patterns are used to determine if a column should be passed to a
    # sanitizer. The regex pattern that is tested is Classname.column_name - so if a sanitizer needs to be
    # scoped to a specific class only, simply add the classname to the pattern, for example /User.phone_number/
    # would sanitize the phone_number field for a User but not the phone_number field for a Customer.
    # If there are other timestamp columns being used throughout your application, you can added them to this list.
    config.sanitize_column_regex /created_at$|updated_at$/, with: :simple_timestamp

    # Inject FixtureRecord concern into ActiveRecord
    ActiveRecord::Base.include(FixtureRecord)
  end
end
