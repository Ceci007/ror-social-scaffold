class FriendshipsController < ApplicationController
  def index
  end

  def create
    @friendship = current_user.friendships.build(:friend_id => params[:user_id])
    @friendship.confirmed = false
    if @friendship.save
      flash[:notice] = "Added friend."
      redirect_to root_url
    else
      flash[:error] = "Unable to add friend."
      redirect_to root_url
    end
  end
  
  
  def update
  end
  
  def destroy
  end

end
