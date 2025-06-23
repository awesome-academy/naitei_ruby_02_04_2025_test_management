class User < ApplicationRecord
  EXTRA_USER_ATTR = [
    :name,
    :role
  ].freeze

  USER_ATTR = [
    :name,
    :email,
    :password,
    :password_confirmation,
    :role
  ].freeze

  enum role: {user: "user", supervisor: "supervisor"}

  has_many :user_exams, dependent: :restrict_with_exception

  validates :name, presence: true, length: {
    minimum: Settings.user.name.min_length,
    maximum: Settings.user.name.max_length
  }
  validates :role, presence: true, inclusion: {in: roles.keys}

  scope :latest, ->{order(created_at: :desc)}
  scope :search_by_name_or_email, lambda {|query|
    return all if query.blank?

    sanitized_query = "%#{query.downcase}%"

    where("LOWER(name) LIKE :query OR LOWER(email) LIKE :query", query: sanitized_query)
  }

  has_secure_password

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    !active? ? :inactive_account : super
  end
end
