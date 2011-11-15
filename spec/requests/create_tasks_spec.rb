require 'spec_helper'

describe "CreateTasks" do
  describe "GET /tasks/new" do
    before(:each) do
      visit new_task_path
    end
    it "displays a form to create a new task" do
      page.should have_selector("form#new_task")
    end

    it "should have a name field" do
      page.should have_field("Name")
    end

    it "should have a create task button" do
      page.should have_button("Create Task")
    end
  end

  describe "use new task form" do
    before(:each) do
      visit new_task_path
      fill_in("Name", :with => "task 1")
      click_button("Create Task")
    end
    it "should display the todo list" do
      current_path.should == tasks_path
    end
    
  end
end
