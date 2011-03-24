


Fabricator(:user) do
  facebook_object_id Fabricate.sequence(:object_id) {|i| i + rand(10000) }
  name Fabricate.sequence(:name) { |i| "name #{i}" }
end


Fabricator(:offering) do
  facebook_user_id rand(100000)
  user Fabricate(:user)
end


Fabricator(:bid) do
 
end
