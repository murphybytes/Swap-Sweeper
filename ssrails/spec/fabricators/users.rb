Fabricator(:user) do
  facebook_object_id Fabricate.sequence(:facebook_object) { |j| j + 1000 }
  name Fabricate.sequence(:name) { |i| "name #{i}" }
end
