class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order created_at: :desc}
  scope :load_user_id, ->(id){where "user_id = ?", id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum:
    Settings.micropost.content.maximum}
  validate  :picture_size

  private

  # Validates the size of an uploaded picture.
  def picture_size
    return unless picture.size > Settings.micropost.picture.size.megabytes
    errors.add(:picture, I18n.t("models.picture.size"))
  end
end
