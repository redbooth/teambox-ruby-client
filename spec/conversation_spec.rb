require 'spec_helper'

describe Teambox::Conversation do
  before do
    @client = make_teambox_client
    @project = @client.project('earthworks')
  end
  
  it "should query conversations" do
    @project.conversations.length.should_not == 0
  end
  
  it "should make a conversation" do
    conversation = @project.create_conversation({:name => 'Hello', :body => 'World'})
    conversation.name.should == 'Hello'
  end
end
