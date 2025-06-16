class SitemapController < ApplicationController
  def show
    @home_page = Page.find_by(internal_identifier: 'home')
    @pages = Page.where.not(id: @home_page.id).select(:id, :path, :updated_at)
    @actors = Actor.published.select(:id, :slug, :updated_at)
    @materials = Material.published.select(:id, :slug, :updated_at)
    @projects = Project.published.select(:id, :slug, :updated_at)
    @technics = Technic.published.select(:id, :slug, :updated_at)
    @regions = Region.published.select(:id, :slug, :updated_at)

    render layout: false
  end
end
