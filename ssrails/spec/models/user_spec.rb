require 'spec_helper'

describe User do
  it "should have a name" do
    user = User.new
    user.name.should != ""
  end
end
