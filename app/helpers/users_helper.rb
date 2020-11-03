module UsersHelper
  def user_info(user)
    return if current_user?(user)
    
    request = Friendship.find_by(user_id: user.id, friend_id: current_user.id, confirmed: false)
    if request.nil?
      render partial: 'user', locals: { user: user }
    else
      confirm_decline(request)
    end
  end

  def friend_request(user)
    render partial: 'friend', locals: { user: user } if current_user.friendship_created?(user) && !current_user?(user)
  end

  def current_user?(user)
    current_user == user
  end
end
