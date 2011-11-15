require 'spec_helper'

describe TasksController do

  describe "POST create" do
    it "should redirect to the todo list" do
      post create
      response.should redirect_to tasks_path
    end
  end
end
