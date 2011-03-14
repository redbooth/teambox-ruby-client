require 'spec_helper'

describe Teambox::Task do
  before do
    @client = make_teambox_client
    @project = @client.project('earthworks')
    @task_list = @project.task_lists(:count => 1)[0]
  end
  
  it "should query tasks" do
    @project.tasks.length.should_not == 0
  end
  
  it "should make a task" do
    conversation = @project.create_task(@task_list, {:name => 'TELL EVERYONE ABOUT CAPSLOCK DAY'})
    conversation.name.should == 'TELL EVERYONE ABOUT CAPSLOCK DAY'
  end
end
