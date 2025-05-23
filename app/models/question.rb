class Question < ApplicationRecord
  has_many :answers, dependent: :restrict_with_exception
end
