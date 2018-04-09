require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  should belong_to(:user)
  should have_many(:students)
  should have_many(:registrations).through(:students)

  should validate_presence_of(:family_name)
  should validate_presence_of(:parent_first_name)




 
  context "Within context" do
    # create the objects I want with factories
    setup do 
      create_users
      create_families
    end
    
    # and provide a teardown method as well
    teardown do
      delete_families
      delete_users
    end

    should "never allow a family to be destroyed" do 
      assert_equal 3, Family.all.size
      @famOne.destroy
      assert_equal 3, Family.all.size
    end

    should "show have a scope to get families in alphabetical order" do 
      assert_equal ['Baker', 'famThree', 'famTwo'], Family.alphabetical.map{|family| family.family_name}
    end

    should "show have a scope to get active families" do 
      assert_equal ['Baker', 'famTwo'], Family.active.map{|family| family.family_name}.sort
    end

    should "show have a scope to get inactive families" do 
      assert_equal ['famThree'], Family.inactive.map{|family| family.family_name}.sort
    end

    should "remove upcoming registrations associated with family when family made inactive" do 
      create_locations
      create_curriculums
      create_more_curriculums
      create_camps
      create_more_students

    
      create_upcoming_registrations

      assert_equal 3, @famTwo.registrations.size

      @famTwo.update_attribute(:active, false)

      assert_equal 0, Registration.joins(:student).where("family_id = ?", @famTwo.id).size

      deny @famTwo.active
      deny @user1.active


      delete_upcoming_registrations
      delete_more_students
      delete_camps
      delete_more_curriculums
      delete_more_curriculums
      delete_locations
    end

    should "remove upcoming registrations when user tries to destroy" do 
      create_locations
      create_curriculums
      create_more_curriculums
      create_camps
      create_more_students

    
      create_upcoming_registrations

      assert_equal 3, @famTwo.registrations.size

      @famTwo.destroy
      assert_equal 0, Registration.joins(:student).where("family_id = ?", @famTwo.id).size
      deny @famTwo.active
      deny @user1.active

      delete_upcoming_registrations
      delete_more_students
      delete_camps
      delete_more_curriculums
      delete_more_curriculums
      delete_locations
    end



  end
  
end
 