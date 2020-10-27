class FriendshipsController < ApplicationController
  def index
  end

  def create
    @friendship = current_user.friendships.build(:friend_id => params[:user_id])
    @friendship.confirmed = false
    if @friendship.save
      flash[:notice] = "Friend request was successfully sent."
      redirect_to root_url
    else
      flash[:error] = "Unable to add friend."
      redirect_to root_url
    end
  end
  
  
  def update
    @friendship = Friendship.find(params[:id]) 
    @friendship.confirmed = true 

    if @friendship.save 
      redirect_to user_path(current_user.id), notice: "Friend request was successfully confirmed."
    else 
      redirect_to user_path(current_user.id), alert: @friendship.error.full_messages.join('. ').to_s
    end
  end 

  def index    
    @friendships = current_user.friendships    
    @inverse_friendships = current_user.inverse_friendships  
  end
  
  def destroy
  end

end
