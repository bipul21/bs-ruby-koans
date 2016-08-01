require 'test/unit'
require 'securerandom'
require './key_server'

class TestKeyServer < Test::Unit::TestCase


  def test_key_server_functions
    key_server = KeyServer.new

    key = key_server.generate
    assert_not_nil(key)

    another_key = key_server.generate
    assert_not_equal(key,another_key)

    free_return_value = key_server.release another_key.key
    assert_not_nil free_return_value
    next_return_value = key_server.release another_key.key
    assert_nil next_return_value

    key_server.release key.key

    free_key  = key_server.get_free_key
    assert_not_nil(free_key)
    assert_not_nil(key_server.delete(free_key.key))
    assert_nil(key_server.get_key(free_key.key))

  end


end