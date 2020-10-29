class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    timeline_posts
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      timeline_posts
      render :index, alert: 'Post was not created.'
    end
  end

  private

  def timeline_posts
    users = [current_user.id]
    unless Friendship.find_by(user_id: current_user.id, confirmed: true).nil?
      users.push(Friendship.find_by(user_id: current_user.id, confirmed: true).friend_id)
    end
    unless Friendship.find_by(friend_id: current_user.id, confirmed: true).nil?
      users.push(Friendship.find_by(friend_id: current_user.id, confirmed: true).user_id)
    end

    @timeline_posts ||= Post.all.ordered_by_most_recent.where('user_id IN (?)', users)
  end

  def post_params
    params.require(:post).permit(:content)
  end

  # def accessible_posts
  #   result = current_user.posts
  #   inverse_friendships_posts = User.find_by(current_user.inverse_friendships.user_id).posts
  #   friends_posts = current_user.friends.posts
  #   result.concat(friends_posts)
  #   result.concat(inverse_friendships_posts)
  #   result
  # end
end
