module Contexts
  module InstructorContexts
    def create_instructors
      @mark   = FactoryBot.create(:instructor, user: @user3)
      @alex   = FactoryBot.create(:instructor, first_name: "Alex", bio: nil, user: @user4)
      @rachel = FactoryBot.create(:instructor, first_name: "Rachel", bio: nil, active: false, user: @user5)
    end

    def delete_instructors
      @mark.delete
      @alex.delete
      @rachel.delete
    end

    def create_more_instructors
      @mike     = FactoryBot.create(:instructor, first_name: "Mike", last_name: "Ferraco", bio: "A stupendous chess player as you have ever seen.", user: @user6)
      @patrick  = FactoryBot.create(:instructor, first_name: "Patrick", last_name: "Dustmann", bio: "A stupendous chess player as you have ever seen.", user: @user7)
      @austin   = FactoryBot.create(:instructor, first_name: "Austin", last_name: "Bohn", bio: "A stupendous chess player as you have ever seen.", user: @user8)
      @nathan   = FactoryBot.create(:instructor, first_name: "Nathan", last_name: "Hahn", bio: "A stupendous chess player as you have ever seen.", user: @user9)
      @ari      = FactoryBot.create(:instructor, first_name: "Ari", last_name: "Rubinstein", bio: "A stupendous chess player as you have ever seen.", user: @user10)
      @seth     = FactoryBot.create(:instructor, first_name: "Seth", last_name: "Vargo", bio: "A stupendous chess player as you have ever seen.", user: @user11)
      @stafford = FactoryBot.create(:instructor, first_name: "Stafford", last_name: "Brunk", bio: "A stupendous chess player as you have ever seen.", user: @user12)
      @brad     = FactoryBot.create(:instructor, first_name: "Brad", last_name: "Hess", bio: "A stupendous chess player as you have ever seen.", user: @user13)
      @ripta    = FactoryBot.create(:instructor, first_name: "Ripta", last_name: "Pasay", bio: "A stupendous chess player as you have ever seen.", user: @user14)
      @jon      = FactoryBot.create(:instructor, first_name: "Jon", last_name: "Hersh", bio: "A stupendous chess player as you have ever seen.", user: @user15)
      @ashton   = FactoryBot.create(:instructor, first_name: "Ashton", last_name: "Thomas", bio: "A stupendous chess player as you have ever seen.", user: @user16)
      @noah     = FactoryBot.create(:instructor, first_name: "Noah", last_name: "Levin", bio: "A stupendous chess player as you have ever seen.", user: @user17)
    end

    def delete_more_instructors
      @mike.delete
      @patrick.delete
      @austin.delete
      @nathan.delete
      @ari.delete
      @seth.delete
      @stafford.delete
      @brad.delete
      @ripta.delete
      @jon.delete
      @ashton.delete
      @noah.delete
    end
  end
end