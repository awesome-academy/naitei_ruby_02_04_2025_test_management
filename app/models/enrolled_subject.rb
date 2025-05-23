class EnrolledSubject < ApplicationRecord
  belongs_to :user
  belongs_to :subject
end
