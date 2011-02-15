# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ssrails::Application.initialize!

require 'memcache'
CACHE = MemCache.new( "127.0.0.1")
