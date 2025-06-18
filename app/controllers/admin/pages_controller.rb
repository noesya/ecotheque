class Admin::PagesController < Admin::ApplicationController
  
  load_and_authorize_resource

  include Admin::FiltersHelper

  def index
    if active_filters_count > 0
      @pages = @pages.autofilter(params[:filters]).ordered.page(params[:page])
    else
      @root_pages = @pages.root.ordered_by_position
    end
    breadcrumb
  end

  def children
    return unless request.xhr?
    @children = @page.children.ordered_by_position
  end

  def reorder
    authorize!(:reorder, Page)
    parent_page = Page.find(params[:parentId]) if params[:parentId]
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      page = Page.find(id)
      page.update_columns parent_id: parent_page&.id,
                          position: index + 1
    end
  end

  def show
    @logs = @page.logs.ordered.page(params[:page])
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @page.save
      redirect_to [:admin, @page], notice: t('admin.successfully_created_html', model: @page.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @page.update(page_params)
      redirect_to [:admin, @page], notice: t('admin.successfully_updated_html', model: @page.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @page.internal_identifier.present?
      @page.destroy
      redirect_to admin_pages_url, notice: t('admin.successfully_destroyed_html', model: @page.to_s)
    else
      redirect_to admin_pages_url, alert: t('admin.cant_destroy', name: @page.to_s)
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Page.model_name.human(count: 2), admin_pages_path
    if @page
      breadcrumb_for @page.parent if @page.parent
      breadcrumb_for @page
    end
  end

  def page_params
    params.require(:page)
          .permit(
            :name, :slug, :description, :parent_id, :menu_description, :position, :meta_title, :meta_description, :meta_illustration, :meta_description_delete
          )
  end
end
