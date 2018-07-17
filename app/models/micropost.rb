class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.micropost.content.max_length}
  validate :picture_size

  private
  def picture_size
    if picture.size > Settings.picture.max_size.megabytes
      errors.add(:picture, "should be less than #{Settings.picture.max_size}MB")
    end
  end
end
