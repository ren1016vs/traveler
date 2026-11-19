class RoomsController < ApplicationController
  def create
    other_user = User.find(params[:user_id])
    return head :forbidden if other_user == current_user
    return head :forbidden unless current_user.following?(other_user) && other_user.following?(current_user)

    pair = [current_user.id, other_user.id].sort
    room = Room.joins(:entries).where(entries: { user_id: current_user.id }).find do |candidate|
      candidate.entries.pluck(:user_id).sort == pair
    end

    unless room
      Room.transaction do
        room = Room.create!
        room.entries.create!(user: current_user)
        room.entries.create!(user: other_user)
      end
    end

    redirect_to room_path(room)
  end
  def show
    @room = current_user.entries.find_by!(room_id: params[:id]).room
    @messages = @room.messages.order(:created_at)
    @message = Message.new
  end
end