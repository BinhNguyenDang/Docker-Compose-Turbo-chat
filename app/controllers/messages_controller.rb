class MessagesController < ApplicationController
    def create
      # Create a new message associated with the current user
      @message = current_user.messages.create(
      body: msg_params[:body],
      room_id: params[:room_id],
      attachments: msg_params[:attachments]
      )
      unless @message.save
        render turbo_stream:
          turbo_stream.update('flash', partial: "shared/message_error", locals: {message: @message.errors.full_messages.join(", ")})
      end
    end
    
    private
    
    # Strong parameters method to ensure only permitted attributes are allowed
    def msg_params
      params.require(:message).permit(:body, attachments: [])
    end
  end
  