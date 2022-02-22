class User < ApplicationRecord
  has_many :orders
  has_many :carts

  validates :email,
            presence: true,
            uniqueness: { allow_blank: false, case_sensitive: false },
            length: { maximum: 255 }

  validates :first_name, presence: true
  validates :last_name, presence: true
end
