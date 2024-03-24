# FixtureRecord is currently only intended to be loaded in a development environment.
# Change this conditional at your own risk if you want it to load in production.

if Rails.env.development?
  # Inject FixtureRecord after active_record loads
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.include(FixtureRecord)
  end
end
