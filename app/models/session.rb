class Session < ApplicationRecord
  belongs_to :user

  scope :valid, -> { where('expires_at > current_timestamp') }

  def not_expired?
    expires_at > Time.now
  end
end
