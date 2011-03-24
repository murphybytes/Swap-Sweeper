require 'spec_helper'

describe User do
  it "should have a name" do
    user = Fabricate(:user)
    user.name.should_not == ""
  end
end
