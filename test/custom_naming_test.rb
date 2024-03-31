require 'test_helper'

class CustomNaming < ActiveSupport::TestCase
  test 'should allow for use of a custom naming proc' do
    orig = FixtureRecord.naming.dup
    custom_namer = Proc.new { |record| record.class.model_name.param_key.reverse }
    FixtureRecord.config.name_records_with custom_namer
    user = users(:user_one)
    with_fixture_file_reset(User) do
      user.to_test_fixture
      assert_includes  yml_contents_for(User).keys, 'resu'

    end
    FixtureRecord.config.name_records_with orig
  end

  test 'should allow for use of a custom klass' do
    orig = FixtureRecord.naming.dup
    class ReverseNamer
      def call(record)
        record.class.to_s.reverse
      end
    end
    FixtureRecord.config.name_records_with ReverseNamer
    user = users(:user_one)
    with_fixture_file_reset(User, Post) do
      user.to_test_fixture(:posts)
      assert_includes  yml_contents_for(User).keys, 'resU'
      assert_includes  yml_contents_for(Post).keys, 'tsoP'
    end
    FixtureRecord.config.name_records_with orig
  end
end
