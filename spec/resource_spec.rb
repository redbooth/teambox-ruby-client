require 'spec_helper'

describe Teambox::Resource do
  
  describe "with an attached result list" do
    before do
      @result_set = Teambox::ResultSet.new(nil, nil, [], [{'type' => 'User', 'id' => 1}, {'type' => 'User', 'id' => 2}])
      @resource = Teambox::Resource.new({'id' => 123, 'user_id' => 1}, @result_set)
      @data = {'user_id' => 1234}
      @data_ids = {'user_ids' => [11,22,33],
                   'users' => [{'type' => 'User', 'id' => 11, 'login' => 'tom'},
                               {'type' => 'User', 'id' => 22, 'login' => 'dick'},
                               {'type' => 'User', 'id' => 33, 'login' => 'harry'}]}
    end
    
    it "should use the reference list from the list" do
      @resource.references.object_id.should == @result_set.references.object_id
    end
    
    it "should return a user reference from the list" do
      @resource.get_reference('User', 1).class.should == Teambox::User
    end
    
    it "should set a reference" do
      @resource.set_reference('User', {'id' => 3})
      @resource.get_reference('User', 3).class.should == Teambox::User
    end
  
    it "should make a dummy reference" do
      @resource.get_or_make_reference('User', @data, 'user_id').class.should == Teambox::User
    end
  
    it "should make many dummy references" do
      @resource.get_or_make_references('User', @data_ids, 'user_ids').length.should == 3
    end
  
    it "should make many dummy references with dummy data" do
      list = @resource.get_or_make_references('User', @data_ids, 'user_ids', 'users')
      list.length.should == 3
      list.map(&:login).sort.should == ['tom','dick','harry'].sort
    end
  end
  
  describe "without an attached result list" do
    before do
      @resource = Teambox::Resource.new({'id' => 123, 'user_id' => 1, 'references' => [{'type' => 'User', 'id' => 1}, {'type' => 'User', 'id' => 2}]})
      @data = {'user_id' => 1234}
      @data_ids = {'user_ids' => [11,22,33],
                   'users' => [{'type' => 'User', 'id' => 11, 'login' => 'tom'},
                               {'type' => 'User', 'id' => 22, 'login' => 'dick'},
                               {'type' => 'User', 'id' => 33, 'login' => 'harry'}]}
    end
     
    it "should return a user reference" do
      @resource.get_reference('User', 1).class.should == Teambox::User
    end
  
    it "should set a reference" do
      @resource.set_reference('User', {'id' => 3})
      @resource.get_reference('User', 3).class.should == Teambox::User
    end
  
    it "should make a dummy reference" do
      @resource.get_or_make_reference('User', @data, 'user_id').class.should == Teambox::User
    end
  
    it "should make many dummy references" do
      @resource.get_or_make_references('User', @data_ids, 'user_ids').length.should == 3
    end
  
    it "should make many dummy references with dummy data" do
      list = @resource.get_or_make_references('User', @data_ids, 'user_ids', 'users')
      list.length.should == 3
      list.map(&:login).sort.should == ['tom','dick','harry'].sort
    end
  end
end
