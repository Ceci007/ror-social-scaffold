class DupplicateValidator < ActiveModel::Validator
  def validate(record)
    friend1 = Friendship.find_by(user_id: record.user_id, friend_id: record.friend_id)
    friend2 = Friendship.find_by(friend_id: record.user_id, user_id: record.friend_id)
    record.errors[:base].push('This relationship is already created') unless friend1.nil? && friend2.nil?
  end
end

class SelfFriendshipValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base].push("You can't be friends with yourself") if record.user_id == record.friend_id
  end
end

class Friendship < ApplicationRecord
  include ActiveModel::Validations
  # validates_with DupplicateValidator, on: :create
  validates_with SelfFriendshipValidator

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user, presence: true
  validates :friend, presence: true

  def confirm_friend
    # self.update_attributes(confirmed: true)
    Friendship.create!(friend_id: user_id,
                       user_id: friend_id,
                       confirmed: true)
  end
end
