class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  def edit
    breadcrumb
    add_breadcrumb t('menu.my_account')
  end

  def update
    super do
      breadcrumb
      add_breadcrumb t('menu.my_account')
    end
  end

  protected

  def sign_up(resource_name, resource)
    sign_in(resource, event: :authentication)
  end

  def update_resource(resource, params)
    if params[:password].blank?
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:mobile_phone, :first_name, :last_name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:last_name, :first_name, :mobile_phone, :description, :image, :image_delete, :image_infos])
  end
end
