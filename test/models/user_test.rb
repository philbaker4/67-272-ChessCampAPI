require 'test_helper'

class UserTest < ActiveSupport::TestCase


  should have_secure_password


  should validate_presence_of(:username)
  should validate_presence_of(:password_digest)
  should validate_presence_of(:role)
  should validate_presence_of(:email)
  should validate_uniqueness_of(:username).case_insensitive
  should validate_uniqueness_of(:email).case_insensitive


  should allow_value("fred@fred.com").for(:email)
  should allow_value("fred@andrew.cmu.edu").for(:email)
  should allow_value("my_fred@fred.org").for(:email)
  should allow_value("fred123@fred.gov").for(:email)
  should allow_value("my.fred@fred.net").for(:email)
  
  should_not allow_value("fred").for(:email)
  should_not allow_value("fred@fred,com").for(:email)
  should_not allow_value("fred@fred.uk").for(:email)
  should_not allow_value("my fred@fred.com").for(:email)
  should_not allow_value("fred@fred.con").for(:email)



  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)


  should allow_value("admin").for(:role)
  should allow_value("instructor").for(:role)
  should allow_value("parent").for(:role)
  
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("leader").for(:role)
  should_not allow_value(nil).for(:role)

  context "Within context" do 

    setup do
      create_users
    end

    teardown do 
      delete_users
    end


    should "require a password of 4 char or longer for new users" do
      bad_user = FactoryBot.build(:user, username: "tank", password: nil)
      bad_user2 = FactoryBot.build(:user, username: "tank", password: 'a', password_confirmation: 'a')

      deny bad_user.valid?
    end


    should "require passwords to be confirmed and matching" do
      bad_user_1 = FactoryBot.build(:user, username: "tank", password: "secret", password_confirmation: nil)
      deny bad_user_1.valid?
      bad_user_2 = FactoryBot.build(:user, username: "tank", password: "secret", password_confirmation: "sauce")
      deny bad_user_2.valid?
    end

    should 'save phone numbers as a string of 10 digits' do
      assert_equal '1234567890', @user1.phone
      assert_equal '1234567890', @user2.phone

    end

  end
end
