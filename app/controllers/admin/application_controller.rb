class Admin::ApplicationController < ApplicationController

  before_action :authenticate_user!

  layout 'admin/layouts/application'

  protected

  def breadcrumb
    add_breadcrumb t('admin.dashboard'), admin_root_path
  end

  def breadcrumb_for(object)
    return if object.nil?
    object.persisted? ? add_breadcrumb(object.to_s, [:admin, object])
                      : add_breadcrumb(t('create'))
  end

  private

  def default_url_options
    {}
  end

end
