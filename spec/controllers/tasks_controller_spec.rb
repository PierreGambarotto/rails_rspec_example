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

  describe "POST create" do
    before(:each) do
      @new_task_params = {"task" => {"name" => "task_name"}}
      Task.stub(:create) {true }
    end
    it "should create a new Task with the given params" do
      Task.should_receive(:create).with(@new_task_params["task"])
      post :create, @new_task_params
    end

    it "should redirect to tasks_path" do
      post :create, @new_task_params
      response.should redirect_to tasks_path
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @task = stub_model(Task, :id => 4)
      @task.stub(:destroy){ true }
      Task.stub(:find){@task}
    end
    it "should redirect to the tasks list" do
      delete :destroy, {:id => @task.id }
      response.should redirect_to tasks_path
    end

    it "should search the task" do
      Task.should_receive(:find).with(@task.id.to_s).and_return(@task)
      delete :destroy, {:id => @task.id }
    end

    it "should destroy the task" do
      @task.should_receive(:destroy)
      delete :destroy, {:id => @task.id }
    end

  end
end
