class MediaController < ApplicationController
  before_action :load_blob

  def show
    if @blob.variable?
      variant_service = VariantService.compute(@blob, params[:filename_with_transformations], params[:format])
      transformations = variant_service.transformations
      if transformations.empty?
        blob_or_variant_url = url_for @blob
      else
        variant = @blob.variant transformations
        blob_or_variant_url = url_for variant
      end
    else
      blob_or_variant_url = url_for(@blob)
    end
    redirect_to blob_or_variant_url
  end

  protected

  def load_blob
    begin
      @blob = ActiveStorage::Blob.find_signed! params[:signed_id]
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      raise ActiveRecord::RecordNotFound
    end
  end
end
