# == Schema Information
#
# Table name: actors
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class ActorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
