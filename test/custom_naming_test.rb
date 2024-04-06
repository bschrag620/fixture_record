require 'test_helper'

class CustomNaming < ActiveSupport::TestCase
  test 'should allow for use of a custom naming proc' do
    orig = FixtureRecord.name_handler.dup
    custom_namer = Proc.new { |record| record.class.model_name.param_key.reverse }
    FixtureRecord.name_handler = custom_namer
    user = users(:user_one)
    with_fixture_file_reset(User) do
      user.to_fixture_record
      assert_includes  yml_contents_for(User).keys, 'resu'

    end
    FixtureRecord.name_handler = orig
  end

  test 'should allow for use of a custom klass' do
    orig = FixtureRecord.name_handler.dup
    class ReverseNamer
      def call(record)
        record.class.to_s.reverse
      end
    end
    FixtureRecord.name_handler = ReverseNamer
    user = users(:user_one)
    with_fixture_file_reset(User, Post) do
      user.to_fixture_record(:posts)
      assert_includes  yml_contents_for(User).keys, 'resU'
      assert_includes  yml_contents_for(Post).keys, 'tsoP'
    end
    FixtureRecord.name_handler = orig
  end
end
