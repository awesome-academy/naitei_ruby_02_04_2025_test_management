class Subject < ApplicationRecord
  SUBJECT_ATTRS = [
    :name,
    :description
  ].freeze

  has_many :questions, dependent: :restrict_with_exception
  has_many :exams, dependent: :restrict_with_exception

  has_many :enrolled_subjects, dependent: :restrict_with_exception
  has_many :enrolled_users, through: :enrolled_subjects, source: :user

  validates :name, presence: true,
                  uniqueness: true,
                  length: {
                    minimum: Settings.subject.name.min_length,
                    maximum: Settings.subject.name.max_length
                  }
  validates :description, presence: true,
                          length: {
                            maximum: Settings.subject.description.max_length
                          }

  scope :latest, -> { order(created_at: :desc) }
end
