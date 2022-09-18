# user_spec

require 'rails_helper'

describe User do
  context 'user' do
    it 'saving user' do
      expect do
        User.create(email: 'test@gmail.com', password: 'blabla')
      end.to change(User, :count).from(0).to(1)
    end
  end
end
