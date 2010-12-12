class Session < ActiveRecord::Base
  validates_uniqueness_of :oauth2_access_token
end
