class Admin::ApplicationController < ApplicationController

  # before_action :authenticate_user!, :ensure_role!
  # before_action :load_filters, only: :index

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

  def load_filters
    @filters = []
    filter_class_name = "::Filters::#{self.class.to_s.gsub('Controller', '')}"
    # filter_class will be nil if filter does not exist
    filter_class = filter_class_name.safe_constantize
    @filters = filter_class.new(current_user).list unless filter_class.nil?
  end

  private

  def ensure_role!
    redirect_to root_path if current_user.visitor?
  end

end
