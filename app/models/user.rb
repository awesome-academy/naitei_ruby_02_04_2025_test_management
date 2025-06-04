class User < ApplicationRecord
  EXTRA_USER_ATTR = [
    :name,
    :role
  ].freeze

  enum role: {user: "user", supervisor: "supervisor"}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :exam_results, dependent: :restrict_with_exception

  validates :name, presence: true, length: {
    minimum: Settings.user.name.min_length,
    maximum: Settings.user.name.max_length
  }
  validates :role, presence: true, inclusion: {in: roles.keys}
end
