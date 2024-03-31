FixtureRecord.configure do |config|
  # To customize how fixtures are named, provide a class the responds to #call or a Proc.
  # The naming object will receive the record and should return a String
  # config.name_records_with = FixtureRecord::Naming::Base

  # Create and register custom sanitizers to format, sanitiize, obfuscate, etc. the data before it is
  # turned into a test fixture. Regex patterns are used to determine if a column should be passed to a
  # sanitizer. The regex pattern that is tested is Classname.column_name - so if a sanitizer needs to be
  # scoped to a specific class only, simply add the classname to the pattern, for example /User.phone_number/
  # would sanitize the phone_number field for a User but not the phone_number field for a Customer.
  # If there are other timestamp columns being used throughout your application, you can added them to this list.
  config.sanitize_pattern /created_at$|updated_at$/, with: :simple_timestamp

  # Inject FixtureRecord concern into ActiveRecord
  ActiveRecord::Base.include(FixtureRecord)
end
