class MaterialsController < ApplicationController
  include ResourceWithStructure

  def index
    @facets = Material::Facets.new params[:facets]
    @materials = @facets.results.ordered.page params[:page]
    breadcrumb
  end

  def show
    @material = Material.find_by!(slug: params[:id])
    @new_comment = User::Comment.new(about: @material) if current_user
    breadcrumb
    add_breadcrumb @material
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Material.model_name.human(count: 2), materials_path
  end
end
