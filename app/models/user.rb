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
  # Define a callback to broadcast an update after a user is created (def function below)
  after_create_commit { broadcast_update }
  # Define association: a user has many messages
  has_many :messages
  # Define an Active Storage attachment for user avatars
  has_one_attached :avatar
  # Define an enumeration for user status with three possible values: offline, away, and online
  enum status: %i[offline away online]

  # Define a callback to add a default avatar (if none is attached) after a user is created or updated
  # When a new user is created (create event) or an existing user is updated (update event), the add_default_avatar method will be invoked.
  after_commit :add_default_avatar, on: %i[create update]
  # Generates a resized thumbnail of the user's avatar
  def avatar_thumbnail
    avatar.variant(resize_to_limit: [150,150]).processed
  end
   # Generates a resized avatar for use in chat
  def chat_avatar
    avatar.variant(resize_to_limit: [50,50]).processed
  end

  # Broadcasts an update to the user's status
  def broadcast_update
    broadcast_replace_to 'user_status', partial: "users/status", user: self
  end
   # Maps user status to corresponding CSS class for styling
  def status_to_css
    case status
    when 'online'
      'bg-success'
    when 'away'
      'bg-warning'
    when 'offine'
      'bg-dark'
    else
      'bg-dark'
    end
  end

  private
   # Adds a default avatar if none is attached
  def add_default_avatar
    return if avatar.attached?

      avatar.attach(
        io:File.open(Rails.root.join('app', 'assets', 'images', 'default_profile.jpg')),
        filename: 'default_profile.jpg',
        content_type: 'image/jpg'
      )
  end
end

