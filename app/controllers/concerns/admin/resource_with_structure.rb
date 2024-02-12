module Admin::ResourceWithStructure
  extend ActiveSupport::Concern

  protected

  def structure_values_permitted_attributes
    [
      :id, :item_id, :text, :_destroy,
      :option_ids, option_ids: [],
      files_attributes: [:id, :file, :file_delete, :_destroy]
    ]
  end
end