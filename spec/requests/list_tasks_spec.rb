require 'spec_helper'

describe "ListTasks" do

  before(:each) do
    @tasks = [Task.create(:name => 'task1', :done => false),
              Task.create(:name => 'task2', :done => true),
              Task.create(:name => 'task3', :done => false)]
    visit tasks_path
  end
    
  describe "GET /list_tasks" do
    it "should display each task name" do
      @tasks.each{|t| page.should have_content t.name}
    end
  end
end
