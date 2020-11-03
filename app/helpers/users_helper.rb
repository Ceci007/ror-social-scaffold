module UsersHelper
  def user_info(user)
    return if current_user?(user)
    
    if current_user.friends.include?(user)
      render partial: 'user', locals: { user: user }
    elsif current_user.pending_friends.include?(user)
      render partial: 'users/pending', locals: { user: user } 
    elsif current_user.friend_requests.include?(user) 
      request = Friendship.find_by(user_id: user.id, friend_id: current_user.id, confirmed: false)
      render partial: 'friendships/confirm_decline', locals: { request: request } 
    else
      friend_request(user)
    end
  end

  def friend_request(user)
    render partial: 'friend', locals: { user: user } if current_user.friendship_created?(user) && !current_user?(user)
  end

  def current_user?(user)
    current_user == user
  end
end
