class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  scope :all_except, -> (user) { where.not(id: user)} # prevent displaying our own name in logging user
  after_create_commit{broadcast_append_to "users"}
  has_many :messages
end
