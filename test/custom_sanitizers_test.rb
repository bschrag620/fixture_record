require 'test_helper'

class CustomSanitizer < ActiveSupport::TestCase
  test 'should allow for use of a custom class that is not registered' do
    class ReverseCreatedAt
      def cast(value)
        value.to_s.reverse
      end
    end

    FixtureRecord.sanitize_column_regex /created_at/, with: ReverseCreatedAt

    user = users(:user_one)
    with_fixture_file_reset(User) do
      user.to_fixture_record
      user_content = yml_contents_for(User)

      assert_equal user_content.dig(user.test_fixture_name, 'created_at'), user.created_at.to_s.reverse
    end
    FixtureRecord.registry.deregister ReverseCreatedAt
  end
end
