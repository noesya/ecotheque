class ProjectsController < ApplicationController

  def index
    @projects = Project.all.ordered.page(params[:page])
    breadcrumb
  end

  def show
    @project = Project.find_by!(slug: params[:slug])
    breadcrumb
    add_breadcrumb @project
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Project.model_name.human(count: 2), projects_path
  end

end
