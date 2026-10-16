# == Schema Information
#
# Table name: user_comments
#
#  id          :uuid             not null, primary key
#  about_type  :string           not null, indexed => [about_id]
#  status      :integer          default("pending")
#  text        :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  about_id    :uuid             not null, indexed => [about_type]
#  reply_to_id :uuid             indexed
#  user_id     :uuid             not null, indexed
#
# Indexes
#
#  index_user_comments_on_about        (about_type,about_id)
#  index_user_comments_on_reply_to_id  (reply_to_id)
#  index_user_comments_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_85d7ddc68c  (reply_to_id => user_comments.id)
#  fk_rails_c4e95a001e  (user_id => users.id)
#
class User::Comment < ApplicationRecord
  belongs_to :user
  belongs_to :about, polymorphic: true
  belongs_to :reply_to,
              class_name: 'User::Comment',
              optional: true

  has_many :replies,
            class_name: 'User::Comment',
            foreign_key: :reply_to,
            dependent: :destroy

  scope :ordered, -> { order(created_at: :desc) }
  scope :root, -> { where(reply_to_id: nil) }
  scope :published, -> { where(status: [:pending, :approved]) }

  scope :autofilter, -> (parameters) { ::Filters::Autofilter.new(self, parameters).filter }
  scope :autofilter_search, -> (term) {
    where("unaccent(user_comments.title) ILIKE unaccent(:term) OR unaccent(user_comments.text) ILIKE unaccent(:term)", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :autofilter_status, -> (value) { where(status: value) }

  validates_presence_of :title

  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2
  }

  def new_reply
    User::Comment.new reply_to: self, about: about
  end

  def to_s
    "#{title}"
  end
end
