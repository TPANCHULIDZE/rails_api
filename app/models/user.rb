class User < ApplicationRecord
  has_secure_password

  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :username, presence: true
end
