class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  # may be commmented out
  has_many :friendships
  has_many :inverse_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: "friend_id"
  # may be commmented out
  # has_many :friends, through: :friendships

  # Users who have to confirm friendship
  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: "Friendship", foreign_key: "user_id"
  has_many :friends, through: :confirmed_friendships

  # Users who need to confirm friendship
  has_many :pending_friendships, -> { where confirmed: false }, class_name: "Friendship", foreign_key: "user_id"
  has_many :pending_friends, through: :pending_friendships, source: :friend

  # Users who requested to be friends (needed for notifications)
  # traited
  # has_many :inverted_friendships, -> { where confirmed: false }, class_name: "Friendship", foreign_key: "friend_id"
  has_many :friend_requests, through: :inverse_friendships, source: :user

  def friends_and_own_posts
    Post.ordered_by_most_recent.where(user: (self.friends).push(self))
    # This will produce SQL query with IN. Something like: select * from posts where user_id IN (1,45,874,43);
  end

  def friendship_created?(friend)
    friendships.find_by(friend_id: friend.id).nil? && created_inverse?(friend)
  end

  def created_inverse?(friend)
    friend.friendships.find_by(friend_id: id).nil?
  end

  def friendship_invited?(user)
    result = !friendships.find_by(user_id: user.id, confirmed: false).nil?
    result
  end

  def confirm_inverse?(friend)
    !friendships.find_by(friend_id: friend.id, confirmed: false).nil?
  end

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_array += inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    friends_array.compact
  end
end
