class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # Define a scope to fetch all users except the current user
  scope :all_except, -> (user) { where.not(id: user)}
  
  # Define a callback to broadcast a message after a user is created
  # Show new user tab bar once a users is sign up in real time
  # append to "users" in div with users id in the index.html.erb
  after_create_commit { broadcast_append_to "users" }
  
  # Define association: a user has many messages
  has_many :messages
end

