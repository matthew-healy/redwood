# frozen_string_literal: true

require "test/unit"
require_relative "../lib/redwood"

class RedwoodTest < Test::Unit::TestCase
  def test_simple_policy
    policy = Cedar::PolicySet.new(
      <<~CEDAR
        permit(
          principal == User::"alice",
          action in [Action::"view", Action::"edit"],
          resource == Subscription::"abc"
        );
      CEDAR
    )

    assert {
      policy.authorized?(
        'User::"alice"',
        'Action::"view"',
        'Subscription::"abc"'
      )
    }
    assert {
      !policy.authorized?(
        'User::"bob"',
        'Action::"edit"',
        'Subscrition::"abc"'
      )
    }
  end
end
