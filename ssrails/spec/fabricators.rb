


Fabricator(:user) do
  facebook_object_id {Fabricate.sequence(:number ) }
  name Fabricate.sequence(:name) { |i| "name #{i}" }
end


Fabricator(:offering) do
  facebook_user_id rand(100000)
  user Fabricate(:user)
end


Fabricator(:bid) do
 
end
