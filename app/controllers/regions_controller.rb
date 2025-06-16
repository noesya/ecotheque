class RegionsController < ApplicationController

  def index
    @regions = Region.published.ordered.page(params[:page])
    breadcrumb
    add_breadcrumb Region.model_name.human(count: 2), regions_path(region_slug: nil)
  end

  def show
    @region = Region.find_by!(slug: params[:id])
    @all_materials = @region.materials.published.ordered
    @materials = @all_materials.limit(4)
    @all_projects = @region.projects.published.ordered
    @projects = @all_projects.limit(4)
    @all_actors = @region.actors.published.ordered
    @actors = @all_actors.limit(4)
    @all_technics = @region.technics.published.ordered
    @technics = @all_technics.limit(4)
    breadcrumb
  end

end
