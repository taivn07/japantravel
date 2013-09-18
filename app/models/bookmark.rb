# coding: utf-8

class Bookmark < ActiveRecord::Base
  attr_accessible :user_id, :bookmarkable_id, :bookmarkable_type

  # references
  belongs_to :bookmarkable, :polymorphic => true
  belongs_to :post
  belongs_to :spot
  belongs_to :user

  # validation
  validates :user_id, presence: true, numericality: true,
    uniqueness: { :scope => [:bookmarkable_id, :bookmarkable_type] }
  validates :bookmarkable_id, presence: true, numericality: true
  validates :bookmarkable_type, :inclusion => { :in => ['Post', 'Spot'] }

  class << self
    def get_spot user_id, limit, offset
      spot_bookmarks = Bookmark.where(user_id: user_id)
                               .where(bookmarkable_type: "Spot")
                               .page(offset).per(limit)

      {
        count: spot_bookmarks.total_count,
        data: spot_bookmarks.map do |bookmark|
          {
            id: bookmark.bookmarkable.try(:id),
            name: bookmark.bookmarkable.try(:name),
            address: bookmark.bookmarkable.try(:address),
            image_url: bookmark.bookmarkable.try(:image)
          }
        end
      } unless spot_bookmarks.empty?
    end

    def find_posts user_id, limit, offset
      bookmarks = where(user_id: user_id)
                  .where(bookmarkable_type: 'Post')
                  .page(offset).per(limit)

      {
        count: bookmarks.total_count,
        data: bookmarks.map do |bookmark|
        {
          id: bookmark.bookmarkable.try(:id),
          post_url: bookmark.bookmarkable.post_url,
          post_thumb_url: bookmark.bookmarkable.post_thumb_url
        }
        end
      } unless bookmarks.empty?
    end
  end
end
