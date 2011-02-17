module Swap
  module Mongo
    def memcache_key
      "#{self.class}-#{self.id}"
    end
  end
end
