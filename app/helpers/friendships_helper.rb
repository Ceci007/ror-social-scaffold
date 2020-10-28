module FriendshipsHelper
  def friend_request?(user)
    current_user.friendships.find_by(friend_id: user.id).nil?
  end

  # Users who have yet to confirme friend requests
  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |invite| invite.user == user }
    friendship.confirmed = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end

end
