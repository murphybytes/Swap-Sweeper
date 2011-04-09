


Fabricator(:user) do
  facebook_object_id {Fabricate.sequence(:number ) }
  name Fabricate.sequence(:name) { |i| "name #{i}" }
end


Fabricator(:offering) do
  facebook_user_id rand(100000)
  user Fabricate(:user)
end


Fabricator(:bid) do
  bidder Fabricate(:user)
end


Fabricator(:bid_message) do
  sending_user = Fabricate(:user) 

  sender sending_user
  receiver Fabricate(:user)
  bid Fabricate(:bid, :bidder => sending_user )
  read false
end
