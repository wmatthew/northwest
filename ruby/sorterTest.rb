# Sorter.rb Unit Tests
# by Matthew Webber
#
# Tests for sorter.rb
#
# dependencies: none
# usage: 
# > ruby sorterTest.rb

$DEBUG = false
$VERBOSE = false
$DUMP = false

require 'test/unit'
require 'sorter.rb'

include Sorter

class TestSym < Test::Unit::TestCase

  def test_getStates
    assert_equal(3,getStates(6,3,3).length);
  end

  def test_getNextStates
    assert_equal(getNextStates([2,2,2].join()).length, 5);
    assert_equal(getNextStates([7,2,1].join()).length, 9);
  end

  def test_sizes
    judgeAll(2, false)
    assert_equal(2, numBad())

    judgeAll(3, false)
    assert_equal(5, numBad())

    judgeAll(4, false)
    assert_equal(10, numBad())

    judgeAll(5, false)
    assert_equal(23, numBad())

    judgeAll(6, false)
    assert_equal(48, numBad())

  end

end
