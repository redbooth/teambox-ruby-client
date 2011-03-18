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
  
  it "should list recent comments in a conversation" do
    recent_comments = @project.conversations[0].recent_comments
    recent_comments.length.should > 0
    recent_comments.each {|c| c.class.should == Teambox::Comment}
  end
  
  it "should list the first comment in a conversation" do
    comment = @project.conversations[0].first_comment
    comment.should_not == nil
    comment.class.should == Teambox::Comment
  end
end
