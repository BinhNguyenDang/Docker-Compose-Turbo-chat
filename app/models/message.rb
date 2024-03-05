class Message < ApplicationRecord
  # Establishes a belongs_to association with the User model
  belongs_to :user
  
  # Establishes a belongs_to association with the Room model
  belongs_to :room
  
  # Defines a callback to broadcast a message after a new message is created
  #self.room: This refers to the room associated with the message that triggered the callback. 
  #By calling self.room, it retrieves the associated room record.
  after_create_commit { broadcast_append_to self.room }

  before_create :confirm_participant

  def confirm_participant
      return unless room.is_private
      is_participant = Participant.where(user_id: self.user.id, room_id: self.room.id).first
      throw :abort unless is_participant
  end
end
