require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) { @user = FactoryBot.create(:user) }
  context 'validations' do
    it 'should required a password' do
      user = User.new(email: "test@test.com")
      user.valid?
      expect(user.errors.messages[:password]).to be_present
    end

    context 'email' do
      it 'should require an email' do
        user = User.new(password: 'tester')
        user.valid?
        expect(user.errors.messages[:email]).to be_present
      end

      context 'formatting' do
        it 'should require the right structure' do
          user = User.new(password: 'tester', email: 'test@')
          user.valid?
          expect(user.errors.messages[:email]).to eq ['invalid']
        end

        it 'should require the right structure' do
          user = User.new(password: 'tester', email: 'test$test.com')
          user.valid?
          expect(user.errors.messages[:email]).to eq ['invalid']
        end
      end
    end
  end

  context 'secure password' do
    it 'should digest the password' do
      expect(@user.password_digest).to_not eq('testpassword')
    end
  end

  context 'login!' do
    it 'should create the session' do
      session = @user.login!
      expect(session).to be_present
    end
  end

  context 'logout!' do
    before(:each) do
      @session_2 = @user.login!
      @session_1 = @user.login!
    end

    it 'should only expire the single session' do
      @user.logout!
      @session_1.reload
      expect(@session_1.expires_at < Time.now).to be true
      expect(@user.has_valid_session?(@session_2.id)).to be true
    end

    it 'should expire all sessions when specified' do
      @user.logout!(all_sessions: true)
      @session_1.reload
      @session_2.reload
      expect(@session_1.expires_at < Time.now).to be true
      expect(@session_2.expires_at < Time.now).to be true
    end
  end
end
