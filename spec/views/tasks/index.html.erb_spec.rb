require 'spec_helper'

describe "tasks/index.html.erb" do
  before(:each) do
    @tasks = [stub_model(Task, :id => 1,:name => 'task1', :done => false),
              stub_model(Task, :id => 2,:name => 'task2', :done => true),
              stub_model(Task, :id => 3,:name => 'task3', :done => false)]
    assign(:tasks, @tasks)
    render
  end

  it "should display a list identified by 'tasks'" do
    rendered.should have_selector("ul#tasks")
  end

  it "should display each task in the list with its name" do
    @tasks.each do |task|
      rendered.should have_selector("ul#tasks li#task_#{task.id}", :text => task.name)
    end
  end

  it "should display a link to create a new task" do
    rendered.should have_link("Create a new Task", :href => new_task_path)
  end

  it "should display each task in the list with a delete link" do
    @tasks.each do |task|
      rendered.should have_selector("li#task_#{task.id} a", :text => "Delete this Task")
    end
  end


end
