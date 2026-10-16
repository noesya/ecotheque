# == Schema Information
#
# Table name: page_blocks
#
#  id                        :uuid             not null, primary key
#  data                      :jsonb
#  kind                      :integer          default("text")
#  name                      :string
#  position                  :integer          default(1)
#  searchable_text_from_data :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  page_id                   :uuid             not null, indexed
#
# Indexes
#
#  index_page_blocks_on_page_id  (page_id)
#
# Foreign Keys
#
#  fk_rails_611934c7ce  (page_id => pages.id)
#
class Page::Block < ApplicationRecord
  include Positionable

  enum :kind, {
    text: 1,
    quote: 2,
    keypoints: 3,
    gallery: 4,
    collapse: 5,
    files: 6
  }, prefix: :kind

  belongs_to :page

  after_commit :denormalize_searchable_text_from_data, on: [:create, :update]
  after_commit :reindex_page

  def data=(value)
    data_hash = value.is_a?(Hash) ? value
                                  : JSON.parse(value)
    write_attribute :data, data_hash
  end

  def data
    attributes['data'].present? ? super
                                : { elements: [] }
  end

  def to_s
    name.present? ? "#{name}"
                  : "Bloc"
  end

  protected

  def set_initial_position
    self.position = page.blocks.count + 1
  end

  def denormalize_searchable_text_from_data
    update_column :searchable_text_from_data,
                  CustomSanitizer.sanitize(to_search, 'string')
  end

  def to_search
    send("to_search_for_#{kind}")
  end

  def to_search_for_text
    concatenate_properties(data, keys: ['text'])
  end

  def to_search_for_quote
    concatenate_properties(data, keys: ['text', 'author'])
  end

  def to_search_for_keypoints
    concatenate_elements(data['elements'], element_keys: ['title', 'text'])
  end

  def to_search_for_gallery
    concatenate_elements(data['elements'], element_keys: ['caption'])
  end

  def to_search_for_collapse
    concatenate_elements(data['elements'], element_keys: ['title', 'text'])
  end

  def to_search_for_files
    elements = data['elements'] || []
    # ["bla bla bli bli blo blo blu blu", "bla bla bli bli blo blo blu blu"]
    # We can't use concatenate_elements because we also need to loop in each element's files.
    pieces = elements.map do |element|
      element_pieces = []
      # ["bla bla", "bli bli"]
      element_pieces << concatenate_properties(element, keys: ['title', 'text'])
      # ["bla bla", "bli bli", "blo blo", "blu blu"]
      element_pieces << concatenate_elements(element['files'], element_keys: ['title'])
      # "bla bla bli bli blo blo blu blu"
      concatenate_array(element_pieces)
    end
    # "bla bla bli bli blo blo blu blu bla bla bli bli blo blo blu blu"
    concatenate_array pieces
  end

  def concatenate_properties(source, keys: [])
    # ["bla bla bla", "blo blo blo"]
    pieces = keys.map { |key| source.dig(key) }
    # "bla bla bla blo blo blo
    concatenate_array pieces
  end

  def concatenate_elements(elements, element_keys: [])
    elements ||= []
    # ["bla bla blo blo", "bla bla blu blu"]
    pieces = elements.map do |element|
      concatenate_properties(element, keys: element_keys)
    end
    # "bla bla blo blo bla bla blu blu"
    concatenate_array pieces
  end

  def concatenate_array(array)
    array.compact_blank.join(' ')
  end

  def reindex_page
    page.reindex
  end
end
