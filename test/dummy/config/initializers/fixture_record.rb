if Rails.env.development? || Rails.env.test?
  # Since this dummy app is used for the unit tests for fixture_record, it needs to
  # properly initialize in the test environment as well.

  # Inject FixtureRecord after active_record loads
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.include(FixtureRecord)
  end
end
