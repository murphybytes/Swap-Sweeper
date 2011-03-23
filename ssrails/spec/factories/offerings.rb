Factory.define :offering do |o|
  o.association :user, :factory => :user
end
