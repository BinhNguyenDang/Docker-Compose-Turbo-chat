class Room < ApplicationRecord
    # Validates the uniqueness of the room name
    validates_uniqueness_of :name
    
    # Defines a scope to fetch public rooms
    scope :public_rooms, -> { where(is_private: false) }
    
    # Sets up a callback to broadcast a message after a new room is created
    after_create_commit { broadcast_append_to "rooms" }
    
    # Establishes an association: a room has many messages
    has_many :messages
  end
  