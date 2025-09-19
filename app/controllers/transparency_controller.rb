class TransparencyController < ApplicationController

  def index
    @current_year = Transparency::Year.ordered.first
    @previous_years = Transparency::Year.where.not(id: @current_year).ordered
    breadcrumb
  end

  def show
    @year = Transparency::Year.find_by(value: params[:year])
    breadcrumb
    add_breadcrumb @year
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('ui.transparency.title'), transparency_path
  end

end