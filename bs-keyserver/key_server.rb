require 'securerandom'
require 'set'
EXPIRATION_TTL = 300
UNBLOCK_TTL = 60

## Key object to hold key and metadata about keys
# @key :  Unique Id for the key
# @timestamp : Timestamp of the creation time of the key

class Keys
  attr_accessor :key
  attr_accessor :timestamp

  def initialize(key = SecureRandom.uuid, ts = Time.now.to_i)
    @key = key
    @timestamp = ts
  end

  def refresh
    @timestamp = Time.now.to_i
  end

  def is_free?
    (Time.now.to_i - @timestamp > UNBLOCK_TTL)
  end

  def is_expired?
    (Time.now.to_i - @timestamp > EXPIRATION_TTL)
  end

  def to_json
    {:key => @key}.to_json
  end

end


## Keyserver to hold the keys and other methods
# @keys :  Hashmap to hold key(uuid) to Key object mapping
## @free : An array list (better with set) to store free keys which means a entry in keys exists

class KeyServer
  attr_reader :keys
  attr_reader :free_keys

  def initialize
    @keys = { }
    @free_keys = Set.new []
  end

  def get_key(key)
    @keys[key]
  end

  #E1
  def generate
    key = Keys.new
    @keys[key.key] = key
    key
  end

  # E2
  def get_free_key
    free_key = @free_keys.to_a.sample
    @free_keys.delete free_key
    @keys[free_key]
  end

  # E3
  def unblock(key)
    unless @free_keys.include? key
      @free_keys << key
      return true
    end
    nil
  end

  #E4
  def delete(key)
    @free_keys.delete key
    @keys.delete key
    true
  end

  #E5
  def refresh(key)
    access_key = @keys[key]
    if access_key != nil
      @keys[key].refresh
      @free_keys.delete key
      return true
    end
    nil
  end

  def cleanup
    @keys.each do |key, val|
      if val.is_expired?
        self.delete key
      elsif val.is_free?
        self.unblock key
      end
    end
  end
end