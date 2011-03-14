require 'spec_helper'

describe Teambox::Project do
  before do
    @client = make_teambox_client
  end
  
  it "should query a project" do
    @client.project('earthworks').permalink.should == 'earthworks'
  end
end
