class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @users = @users.autofilter(params[:filters])
                   .ordered_by_date
    respond_to do |format|
      format.html {
        @users = @users.page(params[:page])
        breadcrumb
      }
      format.xlsx {
        @user_ids = @users.pluck(:id)
        filename = "users-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        if @users.count > 1000
          Admin::ExportUsersJob.perform_later(user: current_user, filename: filename, user_ids: @user_ids)
          redirect_back fallback_location: admin_users_url,
                        notice: t('admin.export_launched')
        else
          response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
        end
      }
    end
  end

  def show
    @logs = @user.logs.ordered.page(params[:page])
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def update
    @user.modified_by = current_user
    @user.skip_reconfirmation!
    if @user.update(user_params)
      redirect_to [:admin, @user], notice: t('admin.successfully_updated_html', model: @user.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def unlock
    if @user.access_locked? || @user.max_login_attempts?
      @user.unlock_access!
      @user.unlock_mfa!
      redirect_back(fallback_location: [:admin, @user], notice: t('admin.users_alerts.successfully_unlocked_html', model: @user.to_s))
    else
      redirect_back(fallback_location: [:admin, @user], alert: t('admin.users_alerts.not_locked_html', model: @user.to_s))
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: t('admin.successfully_destroyed_html', model: @user.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb User.model_name.human(count: 2), admin_users_path
    if @user
      if @user.persisted?
        add_breadcrumb @user, [:admin, @user]
      else
        add_breadcrumb t('create')
      end
    end
  end

  def user_params
    params.require(:user).permit(:image, :image_delete, :image_infos, :last_name, :first_name, :mobile_phone, :email, :role, :website, :description, :allow_listing)
  end

end
