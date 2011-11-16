require 'spec_helper'

describe "DeleteTasks" do
  before(:each) do
    @tasks = [Task.create(:name => 'task1', :done => false),
              Task.create(:name => 'task2', :done => true),
              Task.create(:name => 'task3', :done => false)]
    visit tasks_path
  end

  describe "a task in the list" do
    it "should have a delete button" do
      visit tasks_path
      @tasks.each{|task| page.should have_link("li a", :href => task_path, :method => 'delete')}
    end
  end

end
