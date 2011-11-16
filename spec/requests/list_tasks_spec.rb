require 'spec_helper'

describe "ListTasks" do

  before(:each) do
    @tasks = [Task.create(:name => 'task1', :done => false),
              Task.create(:name => 'task2', :done => true),
              Task.create(:name => 'task3', :done => false)]
    visit tasks_path
  end
    
  describe "GET /tasks" do
    it "should display each task name" do
      @tasks.each{|t| page.should have_content t.name}
    end

    it "should display a link to create a new task" do
      page.should have_link("Create a new Task", :href => new_task_path)
    end
  end


end
