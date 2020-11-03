require 'rails_helper'

RSpec.describe 'Likes/Dislikes management', type: :feature do
  let(:user) { User.create(name: 'Youcef', email: 'youcefabdellani@gmail.com', password: 'password123') }
  let(:friend) { User.create(name: 'Cecilia', email: 'cecibenitezca@gmail.com', password: 'password123') }

  scenario 'Make a like on a post' do
    user.posts.build(content: 'maradona was a good player').save
    user.friendships.build(friend_id: friend.id, confirmed: true).save
    friend.friendships.build(friend_id: user.id, confirmed: true).save
    visit root_path
    fill_in 'user_email', with: friend.email
    fill_in 'user_password', with: friend.password
    click_on 'Log in'
    sleep(3)
    expect(page).to have_content('Signed in successfully.')
    expect(page).to have_content(user.name)
    expect(page).to have_content('maradona was a good player')
    click_on 'Like!'
    sleep(3)
    expect(page).to have_content('You liked a post.')
    expect(page).to have_content('Dislike!')
  end

  scenario 'Make a dislike on a post' do
    user.posts.build(content: 'maradona was a good player').save
    user.friendships.build(friend_id: friend.id, confirmed: true).save
    friend.friendships.build(friend_id: user.id, confirmed: true).save
    visit root_path
    fill_in 'user_email', with: friend.email
    fill_in 'user_password', with: friend.password
    click_on 'Log in'
    sleep(3)
    expect(page).to have_content('Signed in successfully.')
    expect(page).to have_content(user.name)
    expect(page).to have_content('maradona was a good player')
    click_on 'Like!'
    sleep(3)
    expect(page).to have_content('You liked a post.')
    expect(page).to have_content('Dislike!')
    click_on 'Dislike!'
    sleep(3)
    expect(page).to have_content('You disliked a post.')
    expect(page).to have_content('Like!')
  end
end
