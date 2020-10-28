module UsersHelper
  def user_info( user)
    unless current_user?(user)
      request = Friendship.find_by(user_id: user.id, friend_id: current_user.id, confirmed: false)
      unless request.nil?
        confirm_decline(request)
      else
        render partial: 'user', locals: { user: user } 
      end
    end
  end

  def friend_request(user)
    if current_user.friendship_created?(user) && !current_user?(user)
      render partial: 'friend', locals: { user: user }
    # elsif current_user.friendship_invited?(user) && !current_user?(user)
    #   render partial: 'friendships/confirm_decline', locals: { user: user }
    end
  end

  def current_user?(user)
    current_user == user
  end
end
