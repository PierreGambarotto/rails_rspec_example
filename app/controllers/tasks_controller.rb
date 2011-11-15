class TasksController < ApplicationController
  def index

  end

  def new
  end

  def create
    redirect_to tasks_path
  end

end
