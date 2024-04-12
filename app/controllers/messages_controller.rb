class MessagesController < ApplicationController
    include MessagesHelper
  
    before_action :set_message, only: [:destroy, :edit, :update]
    before_action :set_commands
    def create
      # Create a new message associated with the current user
      @message = current_user.messages.create(
      body: msg_params[:body],
      room_id: params[:room_id],
      attachments: msg_params[:attachments]
      )

      @message.body = parse_at_mentions(@message.body)

      parse_slash_commands(@message.body)

      unless @message.save
        render turbo_stream:
          turbo_stream.update('flash', partial: "shared/message_error", locals: {message: @message.errors.full_messages.join(", ")})
      end
    end

    def parse_slash_commands(message)
      if message.start_with?('/')
        command = message.split(' ')
        role_manager(command)
        random_manager(command)
        help_manager(command)
      end
    end

    def role_manager(command)
      if command[0] == @role
        return unless current_user
        return unless current_user.admin?

        target_username = command[1]
        target_role = command[2]
        target_user = User.find_by(username: target_username)
        role = User.roles[target_role]

        @message.body += "=> Assigned #{target_user.username} as #{target_role} \n"
        target_user.update(role:) if target_user && role
      end
    end

    def random_manager(command)
      if command[0] == @random
        lower_bound = command[1].to_i
        upper_bound = command[2].to_i
        random_number = rand(lower_bound..upper_bound)
        @message.body += "=> Rolled between #{lower_bound} and #{upper_bound}. Got: #{random_number}"
      end
    end

    def help_manager(command)
      if command[0] == @help
         result = "\n"
         @command_options.each do |com|
           result += "\n#{com[0]} - #{com[1]}\n"
         end
      @message.body += result
      end
    end

    def destroy
      @room = Room.find(params[:room_id])
      @message = @room.messages.find(params[:id])
      @message.destroy
      flash[:notice] = "Message deleted "
      redirect_to @room
    end

    def edit
    end

    def update
      if params[:message][:remove_attachments].present?
        params[:message][:remove_attachments].each do |attachment_id|
          attachment = @message.attachments.find(attachment_id)
          attachment.purge # or attachment.purge_later for background removal
        end
      end
    
      # Update message body or any other non-attachment attribute
      @message.update(body: msg_params[:body])
    
      # Add new attachments without removing existing ones
      if msg_params[:attachments]
        msg_params[:attachments].each do |new_attachment|
          @message.attachments.attach(new_attachment)
        end
      end
      
      flash[:notice] = "Message edited "
      redirect_to @room, notice: 'Message was successfully updated.'

    end
    
    
    private

    def set_commands
      @role = '/role'
      @random = '/random'
      @help = '/help'

      @command_options = {
        @role => '[username] [role]',
        @random => '[lower_bound] [upper_bound]',
        @help => '[command]'
      }
    end
    
    # Strong parameters method to ensure only permitted attributes are allowed
    def msg_params
      params.require(:message).permit(:body, attachments: [], remove_attachments: [])
    end

    def set_message
      @room = Room.find(params[:room_id])
      @message = @room.messages.find(params[:id])
    end
  end
  
