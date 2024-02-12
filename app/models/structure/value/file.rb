# == Schema Information
#
# Table name: structure_value_files
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  value_id   :uuid             not null, indexed
#
# Indexes
#
#  index_structure_value_files_on_value_id  (value_id)
#
# Foreign Keys
#
#  fk_rails_162821733e  (value_id => structure_values.id)
#
class Structure::Value::File < ApplicationRecord
  belongs_to :value

  has_one_attached_deletable :file
end
