class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
  end

  def create
#    redirect_to tasks_path
    render :text => params.inspect
  end

end
