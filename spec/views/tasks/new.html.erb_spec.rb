require 'spec_helper'

describe "tasks/new.html.erb" do
  before(:each) do
    assign(:task, Task.new)
  end

  it "should have a form with id #new_task" do
    render
    rendered.should have_selector("form#new_task")
  end

  it "should submit to /tasks with a post method" do
    render
    rendered.should have_selector("form#new_task[action='#{tasks_path}']")
    rendered.should have_selector("form#new_task[method='post']")
  end

  it "should have a field named task[name] and identified by #task_name" do
    render
    rendered.should have_selector("input#task_name[name='task[name]']")
    rendered.should have_field("task[name]")
  end

  it "should have a label 'Name' for the field #task_name" do
    render
    rendered.should have_selector("label[for='task_name']", :text => 'Name')
  end

  it "should have a submit button displaying Create Task" do
    render
    rendered.should have_button("Create Task")
  end
end
