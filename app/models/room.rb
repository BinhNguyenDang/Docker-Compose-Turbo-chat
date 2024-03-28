class Room < ApplicationRecord
    # Validates the uniqueness of the room name
    validates_uniqueness_of :name
    
    # Defines a scope to fetch public rooms
    scope :public_rooms, -> { where(is_private: false) }
    
    # Sets up a callback to broadcast a message after a new room is created
    after_update_commit { broadcast_if_public }
    
    # Establishes an association: a room has many messages
    has_many :messages

     # Establishes an association: a room has many participants
    has_many :participants, dependent: :destroy

    # Establishes an association: a room has many joinables
    has_many :joinables, dependent: :destroy

    # Establishes an association: a room has many users joined through joinables/ source: :user indicate what model joined_users uses
    has_many :joined_users, through: :joinables, source: :user

    # Method to broadcast a message after a new room is created if it's public
    def broadcast_if_public
      Rails.logger.info "Broadcasting latest message for room: #{id}"
      return if is_private
      broadcast_latest_message 
    end

    # Method to create a private room and add participants
    def self.create_private_room(users, room_name)
      single_room = Room.create(name: room_name, is_private: true)
      users.each do |user|
        Participant.create(user_id: user.id, room_id: single_room.id)
      end
      return single_room
    end
    # Checks if a user is a participant in a room.
    def participant?(room, user)
      room.participants.where(user: user).exists?
    end

    def latest_message
      messages.includes(:user).order(created_at: :desc).first
    end

    def broadcast_latest_message
      last_message = latest_message

      return unless last_message

      user_target = "room_#{id}_user_last_message"
      sender = Current.user.eql?(last_message.user) ? Current.user : last_message.user

      Turbo::StreamsChannel.broadcast_replace_to("rooms",
                          target: "rooms_#{self.id}_last_message",
                          partial: 'rooms/last_message',
                          locals: {
                            room: self,
                            user: last_message.user,
                            last_message: last_message
                          })
      Turbo::StreamsChannel.broadcast_update_to("rooms",
                          target: user_target,
                          partial: 'users/last_message',
                          locals: {
                            room: self,
                            user: last_message.user,
                            last_message: last_message,
                            sender: sender
                          })
    end
end
  