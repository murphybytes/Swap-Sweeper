require 'spec_helper'

Factory.define :auction do | a |
  a.association :offering, :factory => :offering
  a.association :bids, :factory => :bid
end
