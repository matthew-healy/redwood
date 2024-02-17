# frozen_string_literal: true

require "test/unit"
require_relative "../lib/redwood"

class RedwoodTest < Test::Unit::TestCase
  def test_distance
    assert { distance([0, 0], [0, 4]) == 4 }
    assert { (distance([-1, -1], [1, 1]) - 2.83).abs < 0.002 }
  end
end
