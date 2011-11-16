class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
  end

  def create
    redirect_to tasks_path
  end

end
