class HomeController < ApplicationController
  def index
    @home_page = Page.find_by(internal_identifier: 'home')
    @toolbox_page = Page.find_by(internal_identifier: 'boite-a-outils')
    @regions_count = Region.published.count
    @actors_count = Actor.published.count
    @materials_count = Material.published.count
    @projects_count = Project.published.count
    @technics_count = Technic.published.count
    breadcrumb
  end
end
