module Structured
  extend ActiveSupport::Concern

  included do
    has_many  :structure_values,
              class_name: "Structure::Value",
              as: :about,
              dependent: :destroy
    accepts_nested_attributes_for :structure_values
    
    has_many  :structure_options,
              through: :structure_values,
              source: :options,
              class_name: "Structure::Option"

    # Needed to execute before_validation callback on Structure::Value#files
    validates_associated :structure_values
  end

  def items
    @items ||= Structure::Item.where(about_class: self.class.to_s).ordered
  end
end
