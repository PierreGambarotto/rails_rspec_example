require 'spec_helper'

describe TasksController do

  describe "POST create" do
    it "should redirect to the todo list" do
      post :create
      response.should redirect_to tasks_path
    end
  end

  describe "GET index" do
    before(:each) do
      @tasks = [ :t1, :t2, :t3 ]
      Task.stub(:all) { @tasks }
    end
    it "should get all the task from the database" do
      Task.should_receive(:all)
      get :index
    end

    it "should assigns the list of tasks to @tasks" do
      get :index
      assigns(:tasks).should == @tasks
    end
  end
end
