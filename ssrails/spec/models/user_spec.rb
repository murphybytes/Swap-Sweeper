require 'spec_helper'

describe User do
  it "should have a facebook id" do
    u = User.create_from_facebook_user( {'id' => 1} )
    u.facebook_object_id.should == 1
  end
  it "should have account creation time" do
    before_create = DateTime.now
    u = User.create_from_facebook_user( {'id' => 2}  )
    u.created.second.should >= before_create.second
  end
end
