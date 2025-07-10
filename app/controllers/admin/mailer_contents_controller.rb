class Admin::MailerContentsController < Admin::ApplicationController
  
  load_and_authorize_resource

  def index
    @mailer_contents = @mailer_contents.ordered
    breadcrumb
  end

  def show
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def update
    if @mailer_content.update(mailer_content_params)
      redirect_to [:admin, @mailer_content], notice: t('admin.successfully_updated_html', model: @mailer_contents.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb MailerContent.model_name.human, admin_mailer_contents_path
    breadcrumb_for @mailer_content

  end

  def mailer_content_params
    params.require(:mailer_content)
          .permit(
            :subject, :body, :published
          )
  end
end
