class Post < ApplicationRecord
  belongs_to :user, optional: true
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  acts_as_taggable

  validates :problem, :existing, :solution, :metics, :value, :advantage, :channel, :customer, :cost, :revenue, presence: true

  def previous
    Post.order("created_at desc, id desc").where("created_at <= ? and id < ?", created_at, id).first
  end

  def next
    Post.order("created_at desc, id desc").where("created_at >= ? and id > ?", created_at, id).reverse.first
  end
end
