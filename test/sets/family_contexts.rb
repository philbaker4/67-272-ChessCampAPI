module Contexts
  module FamilyContexts
    def create_families
      @famOne   = FactoryBot.create(:family, user: @user)
      @famTwo  = FactoryBot.create(:family, family_name: "famTwo", parent_first_name: "Alex", user: @user1)
      @famThree = FactoryBot.create(:family, family_name: "famThree", parent_first_name: "Rachel" , active: false, user: @user2)
    end

    def delete_families
      @famOne.delete
      @famTwo.delete
      @famThree.delete
    end

   
  end
end