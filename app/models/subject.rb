class Subject < ApplicationRecord
  SUBJECT_ATTRS = [
    :name,
    :description
  ].freeze

  has_many :questions, dependent: :restrict_with_exception
  has_one :exam, dependent: :restrict_with_exception

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

  scope :latest, ->{order(created_at: :desc)}
  scope :search, -> (query) {
    return all if query.blank?

    search_query = "%#{query.downcase}%"
    where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", search_query, search_query)
  }

  private

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at"]
  end
end
