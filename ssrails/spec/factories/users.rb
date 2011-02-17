
Factory.define :user do |f|
  f.facebook_object_id  1
  f.account_created DateTime.now
  f.last_accessed DateTime.now
end
  
