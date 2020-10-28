class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: :Friendship, foreign_key: :friend_id
  has_many :friends, through: :friendships

  def friendship_created?(friend)
    friendships.find_by(friend_id: friend.id).nil? && created_inverse?(friend)
  end

  def created_inverse?(friend)
    friend.friendships.find_by(friend_id: id).nil?
  end

  def confirm_inverse?(friend)
    !friendships.find_by(friend_id: friend.id, confirmed: false).nil?
  end

  def friends
    friends_array = friendships.map{|friendship| friendship.friend if friendship.confirmed}
    friends_array + inverse_friendships.map{|friendship| friendship.user if friendship.confirmed}
    friends_array.compact
  end
end
