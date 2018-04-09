module Contexts
  module UserContexts
    def create_users
      @user = FactoryBot.create(:user)
      @user1 = FactoryBot.create(:user, username: '0001', email: 'aaaaa@gmail.com', phone: '123-456-7890')
      @user2 = FactoryBot.create(:user, username: '0002', email: 'bbbbb@gmail.com', phone: '123.456.7890')
      @user3 = FactoryBot.create(:user, username: '0003', email: 'ccccc@gmail.com')
      @user4 = FactoryBot.create(:user, username: '0004', email: 'ddddd@gmail.com')
      @user5 = FactoryBot.create(:user, username: '0005', email: 'eeeee@gmail.com')
      @user6 = FactoryBot.create(:user, username: '0006', email: 'fffff@gmail.com')
      @user7 = FactoryBot.create(:user, username: '0007', email: 'ggggg@gmail.com')
      @user8 = FactoryBot.create(:user, username: '0008', email: 'hhhhh@gmail.com')
      @user9 = FactoryBot.create(:user, username: '0009', email: 'iiiii@gmail.com')
      @user10 = FactoryBot.create(:user, username: '0010', email: 'jjjjjj@gmail.com')
      @user11 = FactoryBot.create(:user, username: '0011', email: 'kkkkkk@gmail.com')
      @user12 = FactoryBot.create(:user, username: '0012', email: 'llllll@gmail.com')
      @user13 = FactoryBot.create(:user, username: '0013', email: 'mmmmm@gmail.com')
      @user14 = FactoryBot.create(:user, username: '0014', email: 'nnnnnn@gmail.com')
      @user15 = FactoryBot.create(:user, username: '0015', email: 'ooooo@gmail.com')
      @user16 = FactoryBot.create(:user, username: '0016', email: 'ppppp@gmail.com')
      @user17 = FactoryBot.create(:user, username: '0017', email: 'qqqqq@gmail.com')
      @user18 = FactoryBot.create(:user, username: '0018', email: 'rrrrr@gmail.com')
      @user19 = FactoryBot.create(:user, username: '0019', email: 'sssss@gmail.com')
     

    end

    def delete_users
      @user1.delete
      @user2.delete
      @user3.delete
      @user4.delete
      @user5.delete
      @user6.delete
      @user7.delete
      @user8.delete
      @user9.delete
      @user10.delete
      @user11.delete
      @user12.delete
      @user13.delete
      @user14.delete
      @user15.delete
      @user16.delete
      @user17.delete
      @user18.delete
      @user19.delete
      @user.delete

    end
   
  end
end 