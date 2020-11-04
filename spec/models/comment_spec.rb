require 'rails_helper'

RSpec.describe 'Comment management', type: :feature do
  let(:user) { User.create(name: 'Youcef', email: 'youcefabdellani@gmail.com', password: 'password123') }
  let(:friend) { User.create(name: 'Cecilia', email: 'cecibenitezca@gmail.com', password: 'password123') }

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
end
