class Message < ApplicationRecord
  # Establishes a belongs_to association with the User model
  belongs_to :user
  
  # Establishes a belongs_to association with the Room model
  belongs_to :room
  
  # Defines a callback to broadcast a message after a new message is created
  #self.room: This refers to the room associated with the message that triggered the callback. 
  #By calling self.room, it retrieves the associated room record.
  after_create_commit { broadcast_append_to self.room }
end
