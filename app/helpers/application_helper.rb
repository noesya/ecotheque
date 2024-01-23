module ApplicationHelper
  def masked_email(string)
    string.gsub(/(?<=.{2}).*@.*(?=\S{2})/, '****@****')
  end

  def masked_phone(string)
    string.gsub(/(?<=.{3}).+(?=.{2})/, '*******')
  end

  def masked_string(string)
    string = string.to_s # in case it was nil
    mask_length = [(string.length - 5), 0].max
    mask_length = 30 if mask_length > 30
    string.to_s.gsub(/.+(?=.{5})/, '•' * mask_length)
  end

  def default_images_formats_accepted
    Rails.application.config.default_images_formats.join(', ')
  end

  def default_images_formats_accepted_hint
    t('default_images_hint', formats: default_images_formats_accepted)
  end

  def tag_classes(classes = '')
    "btn btn-outline-dark btn-sm mb-2 rounded-pill #{classes}"
  end

  def tag_classes_disabled(classes = '')
    tag_classes("disabled #{classes}")
  end

  def url_with_optional_region(about, item, option)
    # materials
    resources_class_name = about.class.to_s.downcase.pluralize
    # option_materials_path
    path_name = "option_#{resources_class_name}_path"
    # /materiaux/famille-de-materiaux/plastiques
    public_send(path_name, item_slug: item.slug, option_slug: option.slug)
  end
end
