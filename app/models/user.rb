class User < ApplicationRecord
  has_secure_password

  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "invalid"  },
    uniqueness: { case_sensitive: false },
    length: { minimum: 4, maximum: 254 },
    presence: true

  validates :password,
    presence: true,
    length: { minimum: 8, maximum: 254 }

  validates_confirmation_of :password
  validates_presence_of :password_confirmation, if: :password_digest_changed?

  has_many :sessions

  has_many :dyna_forms

  has_many :form_inputs, through: :dyna_forms

  #
  # Checks if the session is valid for the user
  #
  # @param session_id [String] the uuid of the session
  #
  # @return [Boolean]
  #
  def has_valid_session?(session_id)
    sessions.valid.find_by(id: session_id).present?
  end

  #
  # Logs the user in by creating a new session
  #
  # @return [Session]
  #
  def login!
    Current.session = Session.create!(user: self, expires_at: 1.week.from_now)
    Current.user = Current.session.user
    Current.session
  end

  #
  # Logs the user out - can optionally expire all sessions for the user
  #
  # @param session_id [String] the uuid of the session
  # @param all_sessions [Boolean] optional bit for expiring all sessions - defaults to false
  #
  # @return [void]
  #
  def logout!(all_sessions: false)
    qry = all_sessions ? Current.user.sessions.valid : sessions.where(id: Current.session.id)
    qry.update_all(expires_at: Time.now)
  end
end
