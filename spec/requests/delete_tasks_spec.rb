require 'spec_helper'

describe "DeleteTasks" do
  before(:each) do
    @tasks = [Task.create(:name => 'task1', :done => false),
              Task.create(:name => 'task2', :done => true),
              Task.create(:name => 'task3', :done => false)]
    @task = @tasks[1]
    visit tasks_path
  end

  describe "a task in the list" do
    it "should have a delete button" do
      visit tasks_path
      @tasks.each{|task| page.should have_link("Delete this Task", :href => task_path(task), :method => 'delete')}
    end
  end

  describe "after a click on the delete link on the 2nd task" do
    it "should display the list without the task2" do
      within("li", :text => @task.name) do
        click_on "Delete this Task"
      end
      page.should_not have_content(@task.name)
    end
  end
end
