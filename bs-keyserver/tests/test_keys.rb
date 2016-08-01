require 'test/unit'
require 'securerandom'
require './key_server'

class TestKeys < Test::Unit::TestCase

  def test_keys()
    key = Keys.new
    assert_not_nil(key.key)
    assert_not_nil(key.timestamp)
    assert_equal(false, key.is_expired?)

    time_stamp = key.timestamp
    sleep(1)
    key.refresh
    new_ts =  key.timestamp
    assert_not_equal(new_ts, time_stamp)

    old_key = Keys.new(key= SecureRandom.uuid, ts=(Time.now.to_i - 1000))
    puts old_key.timestamp
    assert_equal(true, old_key.is_expired?)
  end



end