require 'rails_helper'

RSpec.describe 'Post management', type: :feature do
  let(:user) { User.create(name: 'Youcef', email: 'youcefabdellani@gmail.com', password: 'password123') }
  let(:friend) { User.create(name: 'Cecilia', email: 'cecibenitezca@gmail.com', password: 'password123') }

  scenario 'Create new post' do
    visit root_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Log in'
    sleep(3)
    fill_in 'post_content', with: 'maradona was a good player'
    click_on 'Save'
    sleep(3)
    expect(page).to have_content('Post was successfully created.')
    expect(page).to have_content(user.name)
    expect(page).to have_content('maradona was a good player')
  end

  scenario 'Make a comment on a post' do
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
    fill_in 'comment_content', with: 'Yes, he was'
    click_on 'Comment'
    sleep(3)
    expect(page).to have_content('Comment was successfully created.')
    expect(page).to have_content(friend.name)
    expect(page).to have_content('Yes, he was')
  end

  scenario 'See posts from the user and his or her friends in the Timeline' do
    friend.posts.build(content: 'Hello Cecilia').save
    user.posts.build(content: 'Hello Youcef').save
    user.friendships.build(friend_id: friend.id, confirmed: true).save
    friend.friendships.build(friend_id: user.id, confirmed: true).save

    visit root_path
    fill_in 'user_email', with: friend.email
    fill_in 'user_password', with: friend.password
    click_on 'Log in'
    sleep(3)
    expect(page).to have_content('Signed in successfully.')
    expect(page).to have_content(user.name)
    expect(page).to have_content('Hello Youcef')
    expect(page).to have_content(friend.name)
    expect(page).to have_content('Hello Cecilia')

    click_on 'Timeline'
    sleep(3)
    expect(page).to have_content(user.name)
    expect(page).to have_content('Hello Cecilia')
    expect(page).to have_content(friend.name)
    expect(page).to have_content('Hello Youcef')
  end
end
