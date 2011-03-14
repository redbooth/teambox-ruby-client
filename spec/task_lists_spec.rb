require 'spec_helper'

describe Teambox::TaskList do
  before do
    @client = make_teambox_client
    @project = @client.project('earthworks')
  end
  
  it "should query task lists" do
    @project.task_lists.length.should_not == 0
  end
  
  it "should make a task list" do
    conversation = @project.create_task_list({:name => 'CAPSLOCK CRITERIA'})
    conversation.name.should == 'CAPSLOCK CRITERIA'
  end
end
