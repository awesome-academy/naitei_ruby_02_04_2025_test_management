class User < ApplicationRecord
  has_many :enrolled_subjects, dependent: :restrict_with_exception
  has_many :subscribed_subjects, through: :enrolled_subjects, source: :subject

  has_many :exam_results, dependent: :restrict_with_exception
end
