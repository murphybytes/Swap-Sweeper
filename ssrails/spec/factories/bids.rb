require 'spec_helper'

Factory.define :bid do |b|
  b.association :user, :factory => :user
end
