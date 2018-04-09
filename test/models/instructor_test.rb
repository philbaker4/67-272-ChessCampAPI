require 'test_helper'

class InstructorTest < ActiveSupport::TestCase
  # test relationships
  should have_many(:camp_instructors)
  should have_many(:camps).through(:camp_instructors)
  should belong_to(:user)

  # test validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)




  # set up context
  context "Within context" do
    setup do 
      create_users
      create_instructors
    end
    
    teardown do
      delete_instructors
      delete_users
    end

    should "show that there are three instructors in alphabetical order" do
      assert_equal ["Alex", "Mark", "Rachel"], Instructor.alphabetical.all.map(&:first_name)
    end

    should "show that there are two active instructors" do
      assert_equal 2, Instructor.active.size
      assert_equal ["Alex", "Mark"], Instructor.active.all.map(&:first_name).sort
    end
    
    should "show that there is one inactive instructor" do
      assert_equal 1, Instructor.inactive.size
      assert_equal ["Rachel"], Instructor.inactive.all.map(&:first_name).sort
    end

    should "show that there are two instructors needing bios" do
      assert_equal 2, Instructor.needs_bio.size
      assert_equal ["Alex", "Rachel"], Instructor.needs_bio.all.map(&:first_name).sort
    end

    should "show that name method works" do
      assert_equal "Heimann, Mark", @mark.name
      assert_equal "Heimann, Alex", @alex.name
    end
    
    should "show that proper_name method works" do
      assert_equal "Mark Heimann", @mark.proper_name
      assert_equal "Alex Heimann", @alex.proper_name
    end

    should "have a class method to give array of instructors for a given camp" do
      # create additional contexts that are needed
      create_more_instructors
      create_curriculums
      create_active_locations
      create_camps
      create_camp_instructors
      assert_equal ["Alex", "Mark"], Instructor.for_camp(@camp1).map(&:first_name).sort
      assert_equal ["Mark"], Instructor.for_camp(@camp4).map(&:first_name).sort
      # remove those additional contexts
      delete_camp_instructors
      delete_curriculums
      delete_active_locations
      delete_camps
      delete_more_instructors
    end 

    should "only be destroyed if they have not taught a past camp. destroy user." do 
      create_more_instructors
      create_curriculums
      create_more_curriculums
      create_active_locations
      create_camps
      create_past_camps
      create_upcoming_camps
      create_more_camp_instructors
      create_camp_instructors
      

      assert_equal 15, Instructor.all.size
      @mike.destroy
      assert_equal 15, Instructor.all.size
      @user1.update_attribute(:active, true)
      @mark.destroy
      assert_equal 14, Instructor.all.size
      assert_equal 0, User.where("id = ?", @mark.user_id).size
      


      delete_camp_instructors
      delete_past_camps
      delete_upcoming_camps
      delete_more_camp_instructors
      delete_curriculums
      delete_more_curriculums
      delete_active_locations
      delete_camps
      delete_more_instructors
    end

    should "remove upcoming camps, make instructor inactive, make user inactive" do 
      create_more_instructors
      create_curriculums
      create_more_curriculums
      create_active_locations
      create_camps
      create_past_camps
      create_upcoming_camps
      create_more_camp_instructors
      create_camp_instructors

      @mike_c1 = FactoryBot.create(:camp_instructor, instructor: @mike, camp: @camp1)

      assert_equal 1, @mike.camps.upcoming.size

      assert @mike.active
      @mike.destroy
      deny @mike.active

      assert_equal 0, @mike.camps.upcoming.size

      deny @mike.user.active

      delete_camp_instructors
      delete_past_camps
      delete_upcoming_camps
      delete_more_camp_instructors
      delete_curriculums
      delete_more_curriculums
      delete_active_locations
      delete_camps
      delete_more_instructors
    end

    should "make user inactive if instructor is made inactive" do 
      create_more_instructors
      create_curriculums
      create_more_curriculums
      create_active_locations
      create_camps
      create_past_camps
      create_upcoming_camps
      create_more_camp_instructors
      create_camp_instructors

      @mike_c1 = FactoryBot.create(:camp_instructor, instructor: @mike, camp: @camp1)

      assert_equal 1, @mike.camps.upcoming.size

      assert @mike.active
      @mike.update_attribute(:active, false)
      deny @mike.active

      assert_equal 0, @mike.camps.upcoming.size

      deny @mike.user.active

      delete_camp_instructors
      delete_past_camps
      delete_upcoming_camps
      delete_more_camp_instructors
      delete_curriculums
      delete_more_curriculums
      delete_active_locations
      delete_camps
      delete_more_instructors
    end

    

    

  end
end
