require 'spec_helper'

describe Teambox::ResultSet do
  before do
    @client = make_teambox_client
  end
  
  it "should be the result of getting a list of comments" do
    list = @client.get('/projects/earthworks/comments')
    list.class.should == Teambox::ResultSet
    list.each { |c| c.class.should == Teambox::Comment }
    list.first_id.should < list.last_id
  end
  
  it "should get older and newer comments" do
    list = @client.get('/projects/earthworks/comments', {:count => 2})
    list.length.should == 2
    
    # older
    prev_list = list.prev
    prev_list.length.should == 2
    prev_list.first_id.should < list.first_id
    
    # newer
    next_list = prev_list.next
    next_list.length.should == 2
    next_list.first_id.should > prev_list.first_id
    next_list.first_id.should == list.first_id
  end
  
  it "should get all comments" do
    comment_list = []
    list = @client.get('/projects/earthworks/comments', {:count => 2})
    
    while !list.empty?
      list.each {|c| comment_list << c}
      list = list.prev
    end
    
    comment_list.length.should > 10
    uniq_comment_list = comment_list.map{ |c|c.id }.uniq
    uniq_comment_list.length.should == comment_list.length
  end
  
  it "should get associated objects" do
    list = @client.get('/projects/earthworks/comments')
    
    list.each do |l|
      l.user.class.should == Teambox::User
      ([Teambox::Conversation, Teambox::Task].include?(l.target.class)).should == true
      l.target.user_id.should_not == nil
      l.target.user.class.should == Teambox::User
    end
  end
end
