module FriendshipsHelper 
  def friend_request?(user) 
    current_user.friendships.find_by(friend_id: user.id).nil?
  end

  # Users who have yet to confirme friend requests
  def pending_friends
    friendships.map{|friendship| friendship.friend if !friendship.confirmed}.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map{|friendship| friendship.user if !friendship.confirmed}.compact 
  end

  def inverse_friendships_find(user)
    friendship = inverse_friendships.find{|friendship| friendship.user == user}
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find{|friendship| friendship.user == user}
    friendship.confirmed = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end
end