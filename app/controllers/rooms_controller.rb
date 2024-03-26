class RoomsController < ApplicationController
include RoomsHelper
  # Ensure that the user is authenticated before executing any action
  before_action :authenticate_user!
  before_action :set_status
  
  def index
    # Initialize a new instance of the Room model
    @rooms = Room.new

    @joined_rooms = current_user.joined_rooms
    # Retrieve public rooms using the public_rooms scope (definition in room.rb)
    # @rooms = Room.public_rooms
    @rooms = search_rooms
    
    # Fetch all users except the current user, all_except scope ( definition in user.rb)
    @users = User.all_except(current_user)
    
    # Render the 'index' template
    render 'index'
  end
  
  def show
    # Find the room with the specified ID
    @single_room = Room.find(params[:id])
    
    # Initialize a new instance of the Room model
    @rooms = Room.new
    # Retrieve public rooms using the public_rooms scope
    # @rooms = Room.public_rooms
    @rooms = search_rooms

    @joined_rooms = current_user.joined_rooms

    
    # Initialize a new instance of the Message model
    @message = Message.new
    
    # Fetch messages associated with the single room
    # @messages = @single_room.messages.order(created_at: :asc)

    # Fetch messages belonging to a single room, including associated users and ordering them by creation time in descending order
    pagy_messages = @single_room.messages.includes(:user).order(created_at: :desc)
    # Paginate the fetched messages, displaying 10 messages per page, and store pagination metadata in @pagy
    # The paginated messages for the current page are stored in the variable `messages`
    @pagy, messages = pagy(pagy_messages, items: 10)
    # Reverse the order of messages to display the most recent messages at the top
    @messages = messages.reverse
    
    
    # Fetch all users except the current user
    @users = User.all_except(current_user)
    
    # Render the 'index' template
    render 'index'
  end
  
  def create
    # Create a new room with the name specified in the params
    @room = Room.create(name: params["name"])
    
    redirect_to @room
  end

  def search
    @rooms = search_rooms
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('search_results', 
                              partial: 'rooms/search_results', 
                              locals: { rooms: @rooms})
      ]
      end
    end
  end


  def join
    @room = Room.find(params[:id])
    current_user.joined_rooms << @room
    redirect_to rooms_path
  end

  def leave
    @room = Room.find(params[:id])
    current_user.joined_rooms.delete(@room)
    redirect_to rooms_path
  end

  private

  def set_status
    current_user.update!(status: User.statuses[:online]) if current_user
  end
end
