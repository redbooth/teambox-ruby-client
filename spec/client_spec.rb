require 'spec_helper'

describe Teambox::Client do
  before do
    @client = make_teambox_client
  end
  
  it "should authenticate" do
    @client.authenticated?.should == true
  end
  
  it "should return the current user" do
    user = @client.current_user
    user.class.should == Teambox::User
    user.username.should == 'frank'
  end
end
