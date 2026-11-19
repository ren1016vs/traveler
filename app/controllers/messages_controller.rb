class MessagesController < ApplicationController
  def create
    @room = current_user.entries.find_by!(room_id: params[:room_id]).room
    @other_entry = @room.entries.where.not(user_id: current_user.id).first
    return head :forbidden if @other_entry.nil?
    other_user = @other_entry.user
    return head :forbidden unless current_user.following?(other_user) && other_user.following?(current_user)
    @message = @room.messages.build(user: current_user, content: params.dig(:message, :content))
    if @message.save
      redirect_to room_path(@room)
    else
      @messages = @room.messages.order(:created_at)
      render "rooms/show", status: :unprocessable_entity
    end
  end
end
