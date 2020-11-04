require 'rails_helper'

RSpec.describe 'User management', type: :feature do
  let(:user) { User.create(name: 'Youcef', email: 'youcefabdellani@gmail.com', password: 'password123') }
  let(:friend) { User.create(name: 'Cecilia', email: 'cecibenitezca@gmail.com', password: 'password123') }

  scenario 'User sign in successfully' do
    visit root_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Log in'
    sleep(3)
    expect(page).to have_content('Signed in successfully.')
  end
  scenario 'User sign in ends with failure' do
    visit root_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'user.password'
    click_on 'Log in'
    sleep(3)
    expect(page).to have_content('Invalid Email or password.')
  end
end
