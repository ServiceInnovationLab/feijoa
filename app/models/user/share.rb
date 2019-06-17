class User::Share < ApplicationRecord
  belongs_to :user
  belongs_to :recipient, polymorphic: true
  belongs_to :birth_record

  validates :user, presence: true
  validates :recipient, presence: true
  validates :birth_record, presence: true
end
